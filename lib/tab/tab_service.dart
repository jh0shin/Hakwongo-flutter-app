import 'package:flutter/material.dart';

import 'package:hwgo/settings.dart';
import 'file:///C:/Users/jh0sh/Desktop/Github/hwgo/lib/pay/payment.dart';
import 'package:hwgo/learningtest.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  // whether user has valid payment info
  // check at _initState()
  bool _learningTestValidPayment = false;

  // Premium Counseling service apply button
  void _counselingApplyButtonClicked() {
    // TODO : for testing
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => LearningTestPage()
    ));
  }

  // Student learning propensity test button
  void _learningTestButtonClicked() {
    // no valid payment data => goto payment page
    if (_learningTestValidPayment == false) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => PaymentPage()
      ));
    }
    // have valid payment data => goto learning test page
    else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => LearningTestPage()
      ));
    }
  }

  // Back Button Event controller
  Future<bool> _onBackPressed() {
    return showDialog(
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
                        SizedBox(height: screenWidth * 0.11),

                        // Guide Text
                        Material(
                            child: Container(
                                color: Colors.white,
                                child: Text(
                                    "학원고를 종료하시겠습니까?",
                                    style: TextStyle(
                                        fontFamily: 'dream5',
                                        fontSize: screenWidth * 0.05,
                                        letterSpacing: -2,
                                        color: Colors.black
                                    )
                                )
                            )
                        ),

                        // space
                        SizedBox(height: screenWidth * 0.11),

                        // button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // exit
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
                                        "종료",
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

                            // back
                            RawMaterialButton(
                              onPressed: (){
                                Navigator.pop(context, false);
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
                                        "취소",
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
                        ),
                      ],
                    )
                ),
              )
          );
        }
    );
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Material(
          color: bgcolor,
          child: SafeArea(
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    // Premium service introducing area
                    SizedBox(
                        width: screenWidth,
                        height: screenWidth * 0.5,
                        child: Container(
                          margin: EdgeInsets.all(screenWidth * 0.02),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Center(
                              child: Text(
                                  '학원고(주)는 학부모들이 좀 더 쉽게, 좀 더 편하게 자녀를 파악하고, 자녀에게 맞는 교육 방법을 찾도록 도와드립니다.'
                                      +'\n대충 홍보 문구',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'dream5',
                                    fontSize: screenWidth * 0.06,
                                    letterSpacing: -2,
                                    color: Colors.black,
                                  )
                              )
                          ),
                        )
                    ),

                    // Premium counseling service
                    SizedBox(
                        width: screenWidth,
                        height: screenWidth * 0.3,
                        child: Container(
                          margin: EdgeInsets.all(screenWidth * 0.02),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                          ),
                          child: RawMaterialButton(
                            onPressed: _counselingApplyButtonClicked,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    '프리미엄 상담 서비스 신청',
                                    style: TextStyle(
                                      fontFamily: 'dream5',
                                      fontSize: screenWidth * 0.06,
                                      letterSpacing: -2,
                                      color: Colors.black,
                                    )
                                ),
                              ],
                            ),
                          ),
                        )
                    ),

                    // Student learning propensity test
                    SizedBox(
                        width: screenWidth,
                        height: screenWidth * 0.3,
                        child: Container(
                          margin: EdgeInsets.all(screenWidth * 0.02),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: RawMaterialButton(
                            onPressed: _learningTestButtonClicked,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    '학습성향검사',
                                    style: TextStyle(
                                      fontFamily: 'dream5',
                                      fontSize: screenWidth * 0.06,
                                      letterSpacing: -2,
                                      color: Colors.black,
                                    )
                                ),
                                Text(
                                    '2,000 \\ (7일간 이용 가능)',
                                    style: TextStyle(
                                      fontFamily: 'dream5',
                                      fontSize: screenWidth * 0.04,
                                      letterSpacing: -1,
                                      color: Colors.black,
                                    )
                                ),
                              ],
                            )
                          ),
                        )
                    ),

                  ],
                )
              )
          )
      ),
    );
  }
}