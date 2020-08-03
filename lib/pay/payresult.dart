import 'package:flutter/material.dart';
import 'package:hwgo/learningtest.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';

// rest api request
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultPage extends StatefulWidget {

  // constructor
  ResultPage();

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  String _user = '';

  // result data from iamport module
  Map<String, String> result;

  // push pay success data in DB
  void _successPay() async {
    final response = await http.post(
        'http://hakwongo.com:3000/api2/test/paysuccess',
        body: {
          'user' : _user,
          'paytime' : DateTime.now().toString().split('.')[0],
          'validtime' : DateTime.now().add(new Duration(days: 7)).toString().split('.')[0],
          'mid' : result['merchant_uid']
        }
    );
  }

  bool getIsSuccessed(Map<String, String> result) {
    if (result['imp_success'] == 'true') {
      _successPay();
      return true;
    }
    if (result['success'] == 'true') {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    // get logged in user id from UserBloc
    _user = BlocProvider.of<UserBloc>(context).currentState.toString()
        .split(",")[0].split(": ")[1];
  }

  @override
  Widget build(BuildContext context) {
    result = ModalRoute.of(context).settings.arguments;
    bool isSuccessed = getIsSuccessed(result);

    return isSuccessed
      ? LearningTestPage()
      : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isSuccessed ? '성공하였습니다' : '실패하였습니다',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 50.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text('아임포트 번호', style: TextStyle(color: Colors.grey))
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(result['imp_uid'] ?? '-'),
                    ),
                  ],
                ),
              ),
              isSuccessed ? Container(
                padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text('주문 번호', style: TextStyle(color: Colors.grey))
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(result['merchant_uid'] ?? '-'),
                    ),
                  ],
                ),
              ) : Container(
                padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text('에러 메시지', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(result['error_msg'] ?? '-'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}