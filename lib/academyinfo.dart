import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwgo/settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/userbloc.dart';

class AcademyInfoPage extends StatefulWidget {
  @override
  _AcademyInfoPageState createState() => _AcademyInfoPageState();
}

class _AcademyInfoPageState extends State<AcademyInfoPage> {

  // comment input
  String _commentInput = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        double screenWidth = MediaQuery.of(context).size.width;

        // back button handler
        // ignore: missing_return
        Future<bool> _onBackPressed() {
          // back button handling
          Navigator.pop(context);
        }

        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Material(
              color: bgcolor,
              child: SafeArea(
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          // title
                          Stack(
                            children: <Widget>[
                              // title
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    width: screenWidth * 0.75,
                                    height: screenWidth * 0.15,
                                    child: Container(
                                        color: bgcolor,
                                        child: Center(
                                          child: Text("무슨무슨 이름이 매우매우매우매우매우긴 학원",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.06,
                                                  letterSpacing: -2,
                                                  color: Colors.white
                                              )
                                          ),
                                        )
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
                                          Navigator.pop(context);
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

                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              width: screenWidth,
                              color: Colors.white,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: <Widget>[
                                  // location map (kakao)
                                  SizedBox(
                                    width: screenWidth,
                                    height: screenWidth * 0.5,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                      child: Center(
                                        child: Text('지도 들어갈 공간'),
                                      )
                                    ),
                                  ),

                                  // location info
                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                        child: Row(
                                          children: <Widget>[
                                            // padding
                                            Container(
                                              padding: EdgeInsets.all(screenWidth * 0.01),
                                            ),

                                            Icon(
                                              Icons.location_on,
                                              size: screenWidth * 0.07,
                                              color: Colors.red,
                                            ),

                                            // padding
                                            Container(
                                              padding: EdgeInsets.all(screenWidth * 0.01),
                                            ),

                                            Flexible(
                                              child: Text(
                                                '경기도 수원시 영통구 반달로 7번길 6 센타프라자 6층 그리고 주소가 길어진다면',
                                                style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.038,
                                                  letterSpacing: -2,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),

                                  // Contour Line
                                  Container(
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Colors.black12),
                                    ),
                                  ),

                                  // comment title and number of comment
                                  SizedBox(
                                    width: screenWidth,
                                    height: screenWidth * 0.5,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                                      child: Column(
                                        children: <Widget>[
                                          // comment title and number of comment, see more btn
                                          Stack(
                                            children: <Widget>[
                                              // title
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '댓글',
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.06,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    Text(
                                                      '(댓글 개수)',
                                                      style: TextStyle(
                                                        fontFamily: 'dream4',
                                                        fontSize: screenWidth * 0.04,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // see more button
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: RawMaterialButton(
                                                  onPressed: (){ /* TODO: see more comment button clicked */ },
                                                  child: Text(
                                                    '전체보기',
                                                    style: TextStyle(
                                                      fontFamily: 'dream3',
                                                      fontSize: screenWidth * 0.03,
                                                      letterSpacing: -1,
                                                      color: Colors.black45
                                                    )
                                                  )
                                                ),
                                              )
                                            ],
                                          ),

                                          // comment write area
                                          Container(
                                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                      width: screenWidth * 0.7,
                                                      height: screenWidth * 0.2,
                                                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 0.5),
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: TextField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        maxLength: 300,
                                                        style: TextStyle(
                                                          fontFamily: 'dream3',
                                                          fontSize: screenWidth * 0.04,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign: TextAlign.start,
                                                        decoration: InputDecoration(
                                                          hintText: '댓글을 입력해 주세요. (최대 300자)',
                                                          border: InputBorder.none,
                                                          focusedBorder: InputBorder.none,
                                                          enabledBorder: InputBorder.none,
                                                          errorBorder: InputBorder.none,
                                                          disabledBorder: InputBorder.none,
                                                        ),
                                                        onChanged: (String str) {
                                                          setState(() {
                                                            _commentInput = str;
                                                          });
                                                        },
                                                      )
                                                  ),

                                                  RawMaterialButton(
                                                      onPressed: (){ /* TODO: comment push to server */ },
                                                      child: Container(
                                                          width: screenWidth * 0.15,
                                                          height: screenWidth * 0.2,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: Colors.black45
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                                  '등록',
                                                                  style: TextStyle(
                                                                    fontFamily: 'dream5',
                                                                    fontSize: screenWidth * 0.04,
                                                                    color: Colors.white,
                                                                    letterSpacing: 2,
                                                                  )
                                                              )
                                                          )
                                                      )
                                                  ),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                  ),


                                  // Contour Line
                                  Container(
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Colors.black12),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                          // scroll over keyboard
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom
                            )
                          ),

                        ],
                      )
                  )
              )
          ),
        );
      }
  );
}