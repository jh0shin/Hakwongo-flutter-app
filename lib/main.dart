import 'package:flutter/material.dart';
import 'package:hwgo/pay/payresult.dart';

// kakao login
import 'package:kakao_flutter_sdk/all.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/blocdelegate.dart';
import 'package:hwgo/bloc/userbloc.dart';

import 'package:hwgo/loading.dart';
import 'package:hwgo/login.dart';
import 'package:hwgo/tab.dart';

void main() {
  // Kakao login native key
  KakaoContext.clientId = "f51f316dd70869825e7caf626feb190d";

  BlocSupervisor.delegate = MasterBlocDelegate();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(builder: (context) => UserBloc()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      return MaterialApp(
        title: 'hakwongo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'dream3'
        ),
        initialRoute: "/",
        routes: {
          "/" : (context) => LoadingPage(),
          "/tab" : (context) => TabPage(),
          "/login" : (context) => LoginPage(),
          "/result" : (context) => ResultPage(),
        }
      );
    }
  );
}