import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hwgo/settings.dart';

// rest api request
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'bloc/userbloc.dart';

class LearningTestPage extends StatefulWidget {
  @override
  _LearningTestPageState createState() => _LearningTestPageState();
}

class _LearningTestPageState extends State<LearningTestPage> {

  // read question from txt file
  List<String> _question;
  String input;
  List<int> _result = [];
  String _resultString = '';

  String _user;

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

  // save test result on db
  void _postTestResult() async {
    _resultString = '';
    for(int item in _result) {
      _resultString += item.toString();
    }

    final response = await http.post(
        'https://hakwongo.com:2052/api2/test/end',
        body: {
          'user' : _user,
          'testtime' : DateTime.now().toString().split(".")[0],
          'result' : _resultString,
        }
    );
  }

  // get learning test questions from txt file
  void _getFields() async {
    input = await rootBundle.loadString('assets/csv/learningtest.txt');
    _question = input.split("\n");
  }

  // get n th question and check if test is end
  void _select(int num) {
    if (_result.length == _questionIndex)
      _result.add(num);
    else
      _result[_questionIndex] = num;

    setState(() {
      if (_questionIndex == (_question.length - 1)) {
        _isTestEnd = true;
        _postTestResult();
      }
      else _questionIndex++;
    });
  }

  @override
  void initState() {
    super.initState();

    _getFields();

    // get logged in user id from UserBloc
    _user = BlocProvider.of<UserBloc>(context).currentState.toString()
        .split(",")[0].split(": ")[1];
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
                  color: bgcolor,
                  child: ListView(
                    children: <Widget>[
                      // title
                      Stack(
                        children: <Widget>[
                          // title
                          SizedBox(
                              width: screenWidth,
                              height: screenWidth * 0.15,
                              child: Container(
                                  color: bgcolor,
                                  child: Center(
                                    child: Text("학습성향검사",
                                        style: TextStyle(
                                            fontFamily: 'dream5',
                                            fontSize: screenWidth * 0.06,
                                            letterSpacing: -2,
                                            color: Colors.white
                                        )
                                    ),
                                  )
                              )
                          ),

                          // back button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.15,
                                child: IconButton(
                                    onPressed: (){
                                      _onBackPressed();
                                    },
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.keyboard_arrow_left,
                                      size: screenWidth * 0.1,
                                      color: Colors.white,
                                    )
                                )
                            ),
                          ),

                        ],
                      ),

                      _questionIndex == -1
                      // question starting page
                          ? Container(
                          color: Colors.white,
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
                          : SizedBox(
                          width: screenWidth,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenWidth * 0.05, screenWidth * 0.05, screenWidth * 0.05),
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              decoration: BoxDecoration(
                                color:  Colors.white,
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: (_questionIndex + 1).toString(),
                                          style: TextStyle(
                                              fontFamily: 'dream6',
                                              fontSize: screenWidth * 0.07,
                                              letterSpacing: -0.7,
                                              color: Colors.black,
                                              height: 1.5
                                          )
                                        ),

                                        TextSpan(
                                            text: ' / ' + _question.length.toString(),
                                            style: TextStyle(
                                                fontFamily: 'dream4',
                                                fontSize: screenWidth * 0.05,
                                                letterSpacing: -0.7,
                                                color: Colors.black,
                                                height: 1.5
                                            )
                                        ),

                                      ]
                                    )
                                  ),

                                  // Question
                                  Text(
                                      _question[_questionIndex],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'dream4',
                                          fontSize: screenWidth * 0.05,
                                          letterSpacing: -0.7,
                                          color: Colors.black,
                                          height: 1.5
                                      )
                                  ),

                                  // Padding
                                  SizedBox(height: screenWidth * 0.1,),

                                  // option
                                  Column(
                                    children: <Widget>[
                                      RawMaterialButton(
                                          onPressed: () => _select(5),
                                          child: SizedBox(
                                              width: screenWidth * 0.8,
                                              height: screenWidth * 0.12,
                                              child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFf5f5f5),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                      "  매우 그렇다",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'dream3',
                                                          fontSize: screenWidth * 0.042,
                                                          letterSpacing: -2,
                                                          color: Colors.black
                                                      )
                                                  )
                                              )
                                          )
                                      ),

                                      // Padding
                                      SizedBox(height: screenWidth * 0.02),

                                      RawMaterialButton(
                                          onPressed: () => _select(4),
                                          child: SizedBox(
                                              width: screenWidth * 0.8,
                                              height: screenWidth * 0.12,
                                              child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFf5f5f5),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                      "  그렇다",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'dream3',
                                                          fontSize: screenWidth * 0.042,
                                                          letterSpacing: -2,
                                                          color: Colors.black
                                                      )
                                                  )
                                              )
                                          )
                                      ),

                                      // Padding
                                      SizedBox(height: screenWidth * 0.02),

                                      RawMaterialButton(
                                          onPressed: () => _select(3),
                                          child: SizedBox(
                                              width: screenWidth * 0.8,
                                              height: screenWidth * 0.12,
                                              child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFf5f5f5),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                      "  보통이다",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'dream3',
                                                          fontSize: screenWidth * 0.042,
                                                          letterSpacing: -2,
                                                          color: Colors.black
                                                      )
                                                  )
                                              )
                                          )
                                      ),

                                      // Padding
                                      SizedBox(height: screenWidth * 0.02),

                                      RawMaterialButton(
                                          onPressed: () => _select(2),
                                          child: SizedBox(
                                              width: screenWidth * 0.8,
                                              height: screenWidth * 0.12,
                                              child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFf5f5f5),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                      "  그렇지 않다",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'dream3',
                                                          fontSize: screenWidth * 0.042,
                                                          letterSpacing: -2,
                                                          color: Colors.black
                                                      )
                                                  )
                                              )
                                          )
                                      ),

                                      // Padding
                                      SizedBox(height: screenWidth * 0.02),

                                      RawMaterialButton(
                                          onPressed: () => _select(1),
                                          child: SizedBox(
                                              width: screenWidth * 0.8,
                                              height: screenWidth * 0.12,
                                              child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFf5f5f5),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                      "  매우 그렇지 않다",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'dream3',
                                                          fontSize: screenWidth * 0.042,
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
                    ],
                  )
              )
          )
      )
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