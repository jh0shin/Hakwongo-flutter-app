import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hwgo/settings.dart';
import 'dart:io';
import 'dart:convert';

// kakao login
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/user.dart';

// apple login
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';

// http
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // kakaotalk app installed => login by app
  // not installed => login by web
  bool _isKakaoTalkInstalled = true;

  // policy check
  bool _isPolicyChecked = false;

  // Policy info
  String _policy;

  @override
  void initState() {
    _initKakaoTalkInstalled();
    _getPolicy();

    print(BlocProvider.of<UserBloc>(context).currentState.toString() + " - DEBUG");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getPolicy() async {
    _policy = await rootBundle.loadString('assets/csv/policy.txt');
  }

  // policy not checked -> show alert
  void _policyNotChecked() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          double screenWidth = MediaQuery.of(context).size.width;

          return Center(
              child: SizedBox(
                width: screenWidth * 0.7,
                height: screenWidth * 0.5,
                child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // space
                        SizedBox(height: screenWidth * 0.1),

                        // guide text
                        Material(
                            child: Container(
                                color: Colors.white,
                                child: Text(
                                    "개인정보 처리 방침에 동의해주세요.",
                                    style: TextStyle(
                                        fontFamily: 'dream3',
                                        fontSize: screenWidth * 0.04,
                                        letterSpacing: -1,
                                        color: Colors.black
                                    )
                                )
                            )
                        ),

                        // space
                        SizedBox(height: screenWidth * 0.1),

                        // ok button
                        RawMaterialButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            width: screenWidth * 0.325,
                            height: screenWidth * 0.1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Colors.black45,
                              ),
                              child: Center(
                                child: Text(
                                    "확인",
                                    style: TextStyle(
                                        fontFamily: 'dream4',
                                        fontSize: screenWidth * 0.05,
                                        letterSpacing: -2,
                                        color: Colors.white
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              )
          );
        }
    );
  }

  // private information policy -> show dialog and show detail
  void _policyClicked() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          double screenWidth = MediaQuery.of(context).size.width;

          return Center(
              child: SizedBox(
                width: screenWidth * 0.8,
                height: screenWidth * 1,
                child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Expanded(
                          child: Material(
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              width: screenWidth,
                              color: Colors.white,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: <Widget>[
                                  Text(
                                      _policy,
                                      style: TextStyle(
                                          fontFamily: 'dream3',
                                          fontSize: screenWidth * 0.03,
                                          letterSpacing: -1,
                                          color: Colors.black
                                      )
                                  ),

                                  // padding
                                  SizedBox( height: screenWidth * 0.01 ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // okay button
                        RawMaterialButton(
                          onPressed: (){
                            Navigator.pop(context, true);
                          },
                          child: SizedBox(
                            width: screenWidth * 0.325,
                            height: screenWidth * 0.1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: bgcolor,
                              ),
                              child: Center(
                                child: Text(
                                    "확인",
                                    style: TextStyle(
                                        fontFamily: 'dream4',
                                        fontSize: screenWidth * 0.05,
                                        letterSpacing: -2,
                                        color: Colors.white
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              )
          );
        }
    );
  }

  // initial kakaotalk install check
  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  // kakao login whether kakaotalk is installed
  _loginWithKakao() async {
    try {
      var code = await ( _isKakaoTalkInstalled
      ? AuthCodeClient.instance.requestWithTalk()
      : AuthCodeClient.instance.request()
      );
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  // issue access token for getting information from kakao api server
  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      BlocProvider.of<UserBloc>(context).dispatch(UserFetchStarted());
      Navigator.of(context).pushReplacementNamed("/tab");
    } catch (e) {
      print("error on issuing access token : $e");
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      // check if kakaotalk is installed
      isKakaoTalkInstalled();

      double screenWidth = MediaQuery.of(context).size.width;

      return Material(
        child: Container(
            color: bgcolor,
            child: SafeArea(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Image.asset(
                            // logo image
                            // image size : 1924 * 1462 px
                            'assets/image/logo.png',
                            width: screenWidth * 0.6,
                            height: screenWidth * 0.6 * (1462 / 1924),
                          ),

                          // padding
                          SizedBox(
                              height: screenWidth * 0.3
                          ),

                          // kakao login button
                          InkWell(
                              child: Image.asset(
                                'assets/image/kakao_login_btn.png',
                                width: screenWidth * 0.8,
                                height: screenWidth * 0.8 * (49 / 300),
                              ),
                              onTap: () {
                                if (_isPolicyChecked == true)
                                  _loginWithKakao();
                                else
                                  _policyNotChecked();
                              }
                          ),

                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.015),
                          ),

//                          // apple login button
//                          SizedBox(
//                            width: screenWidth * 0.8,
//                            height: screenWidth * 0.8 * (49 / 300),
//                            child: SignInWithAppleButton(
//                                onPressed: () async {
//                                  final credential = await SignInWithApple.getAppleIDCredential(
//                                    scopes: [
//                                      AppleIDAuthorizationScopes.email,
//                                      AppleIDAuthorizationScopes.fullName,
//                                    ],
//                                    webAuthenticationOptions: WebAuthenticationOptions(
//                                      // TODO : set items from apple developer portal
//                                      clientId: 'com.service.hakwongo', // services id
//                                      redirectUri: Uri.parse('https://hakwongo.com:2052/auth/callbacks/sign_in_with_apple'),
//                                    ),
//                                    // TODO : Remove these if no need for them
//                                    nonce: 'example-nonce',
//                                    state: 'example-state',
//                                  );
//
//                                  print(credential);
//
//                                  // This is the endpoint that will convert an authorization code obtained
//                                  // via Sign in with Apple into a session in your system
////                                  final signInWithAppleEndpoint = Uri(
//////                                    scheme: 'http',
//////                                    host: 'www.hakwongo.com',
//////                                    path: ':3000/auth/sign_in_with_apple',
//////                                    queryParameters: <String, String>{
//////                                      'code': credential.authorizationCode,
//////                                      'firstName': credential.givenName,
//////                                      'lastName': credential.familyName,
//////                                      'useBundleId':
//////                                      Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
//////                                      // if (credential.state != null) 'state': credential.state,
//////                                      'state': credential.state
//////                                    },
//////                                  );
//                                  final signInWithAppleEndpoint = Uri.encodeFull(
//                                    "https://hakwongo.com:2052/auth/sign_in_with_apple?"
//                                        + "code=" + credential.authorizationCode.toString()
//                                        + "&firstName=" + credential.givenName.toString()
//                                        + "&lastName=" + credential.familyName.toString()
//                                        + "&useBundleId=" + (Platform.isIOS || Platform.isMacOS ? 'true' : 'false')
//                                        + "&state=" + credential.state.toString()
//                                  );
//
//                                  print(signInWithAppleEndpoint);
//
//                                  final session = await http.Client().post(
//                                    signInWithAppleEndpoint,
//                                  );
//
//                                  // If we got this far, a session based on the Apple ID credential has been created in your system,
//                                  // and you can now set this as the app's session
//                                  print(jsonDecode(session.body)["sessionId"].toString().split(" ")[4]);
//
//                                  // TODO : save credential data in device and navigate to main page
//                                  final prefs = await SharedPreferences.getInstance();
//                                  prefs.setString('apple', jsonDecode(session.body)["sessionId"].toString().split(" ")[4]);
//
//                                  Navigator.of(context).pushReplacementNamed("/tab");
//                                }
//                            ),
//                          ),

                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                          ),

                          // private policy agree
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 0, screenWidth * 0.1, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Theme(
                                      data: ThemeData(unselectedWidgetColor: Colors.white),
                                      child: Checkbox(
                                          value: _isPolicyChecked,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _isPolicyChecked  = value;
                                            });
                                          }
                                      )
                                  ),

                                  RawMaterialButton(
                                      onPressed: _policyClicked,
                                      child: Text(
                                        "개인정보 처리 방침에 동의합니다.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontFamily: 'dream3',
                                            fontSize: screenWidth * 0.04,
                                            letterSpacing: -1,
                                            color: Colors.white
                                        ),
                                      )
                                  ),

                                  SizedBox(width: screenWidth * 0.02),
                                ],
                              )
                          ),

                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.05),
                          )
                        ]
                    )
                )
            )
        )
      );
    }
  );
}