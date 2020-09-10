import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';
import 'dart:async';

// apple login
import 'package:shared_preferences/shared_preferences.dart';

// login package
import 'package:kakao_flutter_sdk/all.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  // background color
  Color _bgcolor = const Color(0xFF504f4b);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAccessToken();
      BlocProvider.of<UserBloc>(context).dispatch(UserFetchStarted());
    });
  }

  // check local storage access token
  // Timer for waiting 1 seconds even if navigator get ready
  _checkAccessToken() async {
    var token = await AccessTokenStore.instance.fromStore();

    Timer(Duration(seconds: 1), () async {
//      // check if kakao login token exists
//      if (token.refreshToken == null) {
//        // check if apple login token exists
//        final prefs = await SharedPreferences.getInstance();
//        final appleUser = prefs.getString('apple') ?? '';
//        print(appleUser);
//
//        if (appleUser == '') {
//          // no access token exists
//          Navigator.of(context).pushReplacementNamed("/login");
//        }
//
//        else Navigator.of(context).pushReplacementNamed("/tab");
//      } else {
//        // access token exists
//        Navigator.of(context).pushReplacementNamed("/tab");
//      }

      Navigator.of(context).pushReplacementNamed("/tab");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: _bgcolor,
        child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    // logo image
                    // image size : 1924 * 1462 px
                    'assets/image/logo.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5 * (1462 / 1924),
                  )
                ]
            )
        )
    );
  }
}