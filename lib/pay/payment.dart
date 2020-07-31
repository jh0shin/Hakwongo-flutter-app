import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';

import 'package:hwgo/settings.dart';

import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  // User info
  String _loginUser = '';

  @override
  void initState() {
    super.initState();

    // get logged in user id from UserBloc
    _loginUser = BlocProvider.of<UserBloc>(context).currentState.toString()
        .split(",")[0].split(": ")[1];
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
        color: bgcolor,
        child: SafeArea(
            child: Container(
                color: Colors.white,
                child: IamportPayment(
                  appBar: new AppBar(
                    title: new Text('학습성향검사 결제')
                  ),
                  // Webview loading component
                    initialChild: Container(
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/image/logo.png'),
                                Container(
                                  padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                                  child: Text('잠시만 기다려 주세요...'),
                                )
                              ],
                            )
                        )
                    ),

                    // userCode (necessary)
                    userCode: 'imp45575504', // TODO : company's usercode

                    // payment data
                    data: PaymentData.fromJson({
                      'pg': 'kcp.A52CY',
                      'pay_method': 'card',
                      'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}',
                      'name': '학원고 학습성향검사 테스트', // not necessary
                      'buyer_name': _loginUser,
                      'amount': 100,
                      'buyer_tel': '01048033704',
                      'appScheme': 'hakwongo://result',
                    }),

                    // callback
                    callback: (Map<String, String> result) {
                      Navigator.pushReplacementNamed(context, '/result', arguments: result);
                    }

                )
            )
        )
    );
  }
}