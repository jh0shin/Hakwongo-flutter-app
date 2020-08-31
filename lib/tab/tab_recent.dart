import 'package:flutter/material.dart';

import 'package:hwgo/settings.dart';
import 'package:hwgo/database.dart';
import 'package:hwgo/academyinfo.dart';

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {

  // limit
  int _offset = 0;
  int _limit = 5;
  bool _isResultLeft = true;
  List<AcademyInfo> _recentAcademy = [];
  List<AcademyInfo> _recentAcademyBuffer = [];

  // academy button clicked -> goto academy info page
  void _academyClicked(AcademyInfo _selectedAcademy) {
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) => AcademyInfoPage(_selectedAcademy)
    )
    ).then((value) { setState(() {}); });
  }

  // get more recent result
  void _getMoreRecentAcademy() async {
    _offset += _limit;
    List<AcademyInfo> _tmp = await DBHelper().getAllData(_offset, _limit);
    if (_tmp.length == 0) {
      setState(() {
        _recentAcademyBuffer.clear();
        _isResultLeft = false;
      });
    } else {
      setState(() {
        _recentAcademyBuffer.clear();
        _recentAcademyBuffer.addAll(_tmp);
      });
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
          child: FutureBuilder(
            future: DBHelper().getAllData(_offset, _limit),
            builder: (BuildContext context, AsyncSnapshot<List<AcademyInfo>> snapshot) {

              if (snapshot.hasData) {
                if (_recentAcademy.length == 0) {
                  _recentAcademy.addAll(snapshot.data);
                  _getMoreRecentAcademy();
                }

                return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        // title
                        SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.15,
                            child: Container(
                                color: bgcolor,
                                child: Center(
                                  child: Text("최근 검색한 학원",
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

                        Expanded(
                          child: Container(
                            width: screenWidth,
                            color: Colors.white,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: <Widget>[

                                // Contour line
                                Container(
                                  width: screenWidth * 0.9,
                                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5, color: Colors.black45),
                                  ),
                                ),

                                // liked academy
                                SizedBox(
                                  width: screenWidth,
                                  child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      child: Column(
                                        children: [
//                                          // delete recent logs
//                                          SizedBox(
//                                              width: screenWidth,
//                                              height: screenWidth * 0.14,
//                                              child: Container(
//                                                color: Colors.white,
//                                                child: Column(
//                                                  mainAxisAlignment: MainAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    RawMaterialButton(
//                                                      onPressed: () {
//                                                        setState(() {
//                                                          DBHelper().deleteAll();
//                                                        });
//                                                      },
//                                                      child: Container(
//                                                        alignment: Alignment.center,
//                                                        width: screenWidth * 0.9,
//                                                        padding: EdgeInsets.all(screenWidth * 0.02),
//                                                        child: Row(
//                                                          mainAxisAlignment: MainAxisAlignment.center,
//                                                          children: <Widget>[
//                                                            Icon(
//                                                              Icons.search,
//                                                              size: screenWidth * 0.05
//                                                            ),
//
//                                                            Text(
//                                                                "검색 기록 삭제",
//                                                                style: TextStyle(
//                                                                  fontFamily: 'dream4',
//                                                                  fontSize: screenWidth * 0.05,
//                                                                  letterSpacing: -2,
//                                                                  color: Colors.black,
//                                                                )
//                                                            )
//                                                          ],
//                                                        ),
//                                                      ),
//                                                    ),
//
//                                                    // Contour line
//                                                    Container(
//                                                      width: screenWidth * 0.9,
//                                                      decoration: BoxDecoration(
//                                                        border: Border.all(width: 0.5, color: Colors.black26),
//                                                      ),
//                                                    ),
//
//                                                  ],
//                                                ),
//                                              )
//                                          ),

                                          SizedBox(),

                                        ]
                                        + List.generate(_recentAcademy.length, (index) {
                                          return SizedBox(
                                              width: screenWidth * 0.9,
                                              height: screenWidth * 0.2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () => _academyClicked(_recentAcademy[index]),
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
                                                                        _recentAcademy[index].name,
                                                                        style: TextStyle(
                                                                          fontFamily: 'dream5',
                                                                          fontSize: screenWidth * 0.055,
                                                                          letterSpacing: -2,
                                                                          color: Colors.black,
                                                                        )
                                                                    ),

                                                                    // 학원 주소
                                                                    Text(
                                                                        _recentAcademy[index].addr,
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
                                          );
                                        })
                                        + [
                                          // show more button
                                          _isResultLeft
                                            ? SizedBox(
                                              width: screenWidth * 0.9,
                                              height: screenWidth * 0.1,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  if (_recentAcademyBuffer.length != 0) {
                                                    setState(() {
                                                      _recentAcademy.addAll(_recentAcademyBuffer);
                                                    });
                                                    _getMoreRecentAcademy();
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: screenWidth * 0.9,
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  child: Text(
                                                      "최근 검색한 학원 더보기",
                                                      style: TextStyle(
                                                        fontFamily: 'dream4',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  ),
                                                ),
                                              )
                                            )
                                            : SizedBox(),
                                        ],
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                    )
                );
              }
              else {
                return Center(child: CircularProgressIndicator(), );
              }
            }
          )
        )
      ),
    );
  }
}