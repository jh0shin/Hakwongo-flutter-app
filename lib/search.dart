import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwgo/settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';
import 'package:hwgo/academyinfo.dart';

class SearchPage extends StatefulWidget {
  // search condition
  // access by widget.(variable name)
  String _selectedAddr;
  String _selectedSubject;
  String _selectedAge;

  // constructor
  SearchPage(this._selectedAddr, this._selectedSubject, this._selectedAge);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  // academy button clicked -> goto academy info page
  void _academyClicked() {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => AcademyInfoPage()
      )
    );
  }

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
                        SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.15,
                            child: Container(
                                color: bgcolor,
                                child: Center(
                                  child: Text("검색 결과",
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

                    SizedBox(
                        width: screenWidth,
                        height: screenWidth * 0.12,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                    child: Text(
                                      '필터 :   ' + widget._selectedAddr + ',   ' + widget._selectedSubject + ',   ' + widget._selectedAge,
                                      style: TextStyle(
                                        fontFamily: 'dream5',
                                        fontSize: screenWidth * 0.038,
                                        letterSpacing: -2,
                                        color: Colors.black,
                                      ),
                                    )
                                ),
                              ),

                              // Contour line
                              Container(
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.black26),
                                ),
                              ),

                            ],
                          ),
                        )
                    ),

                    Expanded(
                      child: Container(
                        width: screenWidth,
                        color: Colors.white,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            // academy info(button)
                            SizedBox(
                                width: screenWidth * 0.9,
                                height: screenWidth * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RawMaterialButton(
                                      onPressed: _academyClicked,
                                      child: Container(
                                        width: screenWidth * 0.9,
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 1,
                                              child: Image.asset(
                                                // 1924 * 1462 px
                                                'assets/image/logo.png',
                                                width: screenWidth * 0.2,
                                                height: screenWidth * 0.15,
                                              ),
                                            ),

                                            Flexible(
                                                flex: 4,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    // 학원 이름
                                                    Text(
                                                        "이룸수학 학원",
                                                        style: TextStyle(
                                                          fontFamily: 'dream5',
                                                          fontSize: screenWidth * 0.06,
                                                          letterSpacing: -2,
                                                          color: Colors.black,
                                                        )
                                                    ),

                                                    // 학원 주소
                                                    Text(
                                                        '경기도 수원시 영통구 반달로 7번길 6 센타프라자 6층 그리고 주소가 길어지면',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontFamily:  'dream3',
                                                          fontSize: screenWidth * 0.04,
                                                          letterSpacing: -2,
                                                          color: Colors.black45,
                                                        )
                                                    ),


                                                  ],
                                                )
                                            ),

                                          ],
                                        )
                                      ),
                                    ),

                                    // Contour line
                                    Container(
                                      width: screenWidth * 0.9,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: Colors.black12),
                                      ),
                                    ),
                                  ],
                                )
                            ),

                            // academy info(button)
                            SizedBox(
                                width: screenWidth * 0.9,
                                height: screenWidth * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RawMaterialButton(
                                      onPressed: _academyClicked,
                                      child: Container(
                                        width: screenWidth * 0.9,
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              flex: 1,
                                              child: Image.asset(
                                                // 1924 * 1462 px
                                                'assets/image/logo.png',
                                                width: screenWidth * 0.2,
                                                height: screenWidth * 0.15,
                                              ),
                                            ),

                                            Flexible(
                                                flex: 4,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    // 학원 이름
                                                    Text(
                                                        "이이민민수수학학원원",
                                                        style: TextStyle(
                                                          fontFamily: 'dream5',
                                                          fontSize: screenWidth * 0.06,
                                                          letterSpacing: -2,
                                                          color: Colors.black,
                                                        )
                                                    ),

                                                    // 학원 주소
                                                    Text(
                                                        '경기도 성남시 분당구 수내1동 센타프라자 6층 그리고 주소가 길어지면',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontFamily:  'dream3',
                                                          fontSize: screenWidth * 0.04,
                                                          letterSpacing: -2,
                                                          color: Colors.black45,
                                                        )
                                                    ),


                                                  ],
                                                )
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),

                                    // Contour line
                                    Container(
                                      width: screenWidth * 0.9,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5, color: Colors.black12),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
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