import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/user.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // kakaotalk app installed => login by app
  // not installed => login by web
  bool _isKakaoTalkInstalled = true;

  @override
  void initState() {
    _initKakaoTalkInstalled();
  }

  @override
  void dispose() {
    super.dispose();
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

      return Material(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: Image.asset(
                    'assets/image/kakao_login_btn.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8 * (49 / 300),
                  ),
                  onTap: () {
                    _loginWithKakao();
                  }
                ),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                )
              ]
            )
          )
        )
      );
    }
  );
}