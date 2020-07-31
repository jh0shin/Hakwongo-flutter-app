import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';

import 'package:hwgo/settings.dart';

class LearningTestPage extends StatefulWidget {
  @override
  _LearningTestPageState createState() => _LearningTestPageState();
}

class _LearningTestPageState extends State<LearningTestPage> {

  // read question from txt file
  List<String> _question;
  String input;
  List<int> _result = [];

  // question index
  int _questionIndex = -1;

  bool _isTestEnd = false;

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
                        SizedBox(height: screenWidth * 0.05),

                        // Guide Text
                        Material(
                            child: Container(
                                color: Colors.white,
                                child: Text(
                                    "검사를 종료하시겠습니까?\n검사를 도중에 그만두면 결과가 저장되지 않습니다.",
                                    textAlign: TextAlign.center,
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
                        SizedBox(height: screenWidth * 0.05),

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

  void _getFields() async {
    input = await rootBundle.loadString('assets/csv/learningtest.txt');
    _question = input.split("\n");
  }

  void _select(int num) {
    if (_result.length == _questionIndex)
      _result.add(num);
    else
      _result[_questionIndex] = num;

    setState(() {
      if (_questionIndex == (_question.length - 1))
        _isTestEnd = true;
      else _questionIndex++;
    });
  }

  @override
  void initState() {
    _getFields();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return _isTestEnd
      ? result(context)
      : test(context);
  }

  Widget test(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Material(
          color: bgcolor,
          child: SafeArea(
              child: Container(
                  color: Colors.white,
                  child: _questionIndex == -1
                  // question starting page
                      ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.5,
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                    "학원고의 학습성향 검사는 .... \n"
                                        + "검사에는 약 10~15분의 시간이 소요되며...\n",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'dream5',
                                        fontSize: screenWidth * 0.05,
                                        letterSpacing: -2,
                                        color: Colors.black
                                    )
                                )
                            ),
                          ),

                          // start button
                          RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  _questionIndex++;
                                });
                              },
                              child: SizedBox(
                                  width: screenWidth,
                                  height: screenWidth * 0.2,
                                  child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.all(screenWidth * 0.02),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                          "학습성향검사 시작",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'dream5',
                                              fontSize: screenWidth * 0.05,
                                              letterSpacing: -2,
                                              color: Colors.black
                                          )
                                      )
                                  )
                              )
                          )
                        ],
                      )
                  )
                  // question page
                      : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              _question[_questionIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'dream5',
                                  fontSize: screenWidth * 0.05,
                                  letterSpacing: -2,
                                  color: Colors.black
                              )
                          ),

                          Column(
                            children: <Widget>[
                              RawMaterialButton(
                                  onPressed: () => _select(5),
                                  child: SizedBox(
                                      width: screenWidth,
                                      height: screenWidth * 0.15,
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(screenWidth * 0.02),
                                          margin: EdgeInsets.all(screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                              "매우 그렇다",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.05,
                                                  letterSpacing: -2,
                                                  color: Colors.black
                                              )
                                          )
                                      )
                                  )
                              ),

                              RawMaterialButton(
                                  onPressed: () => _select(4),
                                  child: SizedBox(
                                      width: screenWidth,
                                      height: screenWidth * 0.15,
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(screenWidth * 0.02),
                                          margin: EdgeInsets.all(screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                              "그렇다",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.05,
                                                  letterSpacing: -2,
                                                  color: Colors.black
                                              )
                                          )
                                      )
                                  )
                              ),

                              RawMaterialButton(
                                  onPressed: () => _select(3),
                                  child: SizedBox(
                                      width: screenWidth,
                                      height: screenWidth * 0.15,
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(screenWidth * 0.02),
                                          margin: EdgeInsets.all(screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                              "보통이다",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.05,
                                                  letterSpacing: -2,
                                                  color: Colors.black
                                              )
                                          )
                                      )
                                  )
                              ),

                              RawMaterialButton(
                                  onPressed: () => _select(2),
                                  child: SizedBox(
                                      width: screenWidth,
                                      height: screenWidth * 0.15,
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(screenWidth * 0.02),
                                          margin: EdgeInsets.all(screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                              "그렇지 않다",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.05,
                                                  letterSpacing: -2,
                                                  color: Colors.black
                                              )
                                          )
                                      )
                                  )
                              ),

                              RawMaterialButton(
                                  onPressed: () => _select(1),
                                  child: SizedBox(
                                      width: screenWidth,
                                      height: screenWidth * 0.15,
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(screenWidth * 0.02),
                                          margin: EdgeInsets.all(screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                              "매우 그렇지 않다",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.05,
                                                  letterSpacing: -2,
                                                  color: Colors.black
                                              )
                                          )
                                      )
                                  )
                              )
                            ],
                          )
                        ],
                      )
                  )
              )
          )
      ),
    );
  }

  Widget result(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
        color: bgcolor,
        child: SafeArea(
            child: Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    // padding
                    SizedBox(
                        height: screenWidth * 0.2
                    ),

                    Text(
                        _result.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'dream5',
                            fontSize: screenWidth * 0.05,
                            letterSpacing: -2,
                            color: Colors.black
                        )
                    ),

                    // padding
                    SizedBox(
                        height: screenWidth * 0.2
                    ),

                    Text(
                        "자녀의 학습성향 검사는 다음과 같습니다.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'dream5',
                            fontSize: screenWidth * 0.05,
                            letterSpacing: -2,
                            color: Colors.black
                        )
                    ),
                  ],
                )
            )
        )
    );
  }
}