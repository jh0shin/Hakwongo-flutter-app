import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwgo/settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/userbloc.dart';

// for phone call
import 'package:url_launcher/url_launcher.dart';

class AcademyCommentPage extends StatefulWidget {
  @override
  _AcademyCommentPageState createState() => _AcademyCommentPageState();
}

class _AcademyCommentPageState extends State<AcademyCommentPage> {

  // sort option ( default : like )
  String _sortOption = '인기 댓글 순';

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
                                  // location info
                                  SizedBox(
                                    width: screenWidth,
                                    height: screenWidth * 0.11,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // padding
                                          Container(
                                            padding: EdgeInsets.all(screenWidth * 0.01),
                                          ),

                                          Icon(
                                            Icons.person,
                                            size: screenWidth * 0.07,
                                            color: Colors.black,
                                          ),

                                          // padding
                                          Container(
                                            padding: EdgeInsets.all(screenWidth * 0.01),
                                          ),

                                          Flexible(
                                            flex: 2,
                                            child: RawMaterialButton(
                                              onPressed: (){ /* TODO : show only my comment */ },
                                              child: SizedBox(
                                                height: screenWidth * 0.1,
                                                child: Center(
                                                  child: Text(
                                                    '내 댓글 보기',
                                                    style: TextStyle(
                                                      fontFamily: 'dream5',
                                                      fontSize: screenWidth * 0.038,
                                                      letterSpacing: -2,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ),
                                              )
                                            ),
                                          ),

                                          Flexible(
                                            flex: 3,
                                            child: Container(color: Colors.white),
                                          ),

                                          Flexible(
                                            flex: 2,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: _sortOption,
                                                icon: Icon(Icons.arrow_drop_down),
                                                iconSize: screenWidth * 0.05,
                                                elevation: 15,
                                                style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.038,
                                                  letterSpacing: -2,
                                                  color: Colors.black,
                                                ),
                                                onChanged: (String newOption) {
                                                  setState(() {
                                                    _sortOption = newOption;
                                                  });
                                                },
                                                items: <String>['인기 댓글 순', '시간순']
                                                    .map<DropdownMenuItem<String>>
                                                  ((String value) {
                                                  return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontFamily: 'dream5',
                                                          fontSize: screenWidth * 0.038,
                                                          letterSpacing: -2,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                  );
                                                }).toList(),
                                              )
                                            )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  // Contour Line
                                  Container(
                                    width: screenWidth * 0.9,
                                    margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Colors.black),
                                    ),
                                  ),

                                  // popular comment (1~3)
                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 10일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 54개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '사장님이 친절하고 음식이 맛있어요~',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 11일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 5424개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '스타크래프트버젼1.16.1 돌에 긁힌듯한 상처 가 있어서 검붉은색의 피가 엉켜있었다. ".........?" 로이와 필이 의아 전보를 울리는 모택동군을 시기하여 전투중인 신사군에게 다시 공격을 감행하여 9천명을 사 스타크래프트버젼1.16.1 갑자기 풀린 탓에 다리에 힘이 제대로 들어가지 않았지만 그녀는 이를 악물고 일어섰다. "어 을 해보았다. 불현듯 보여주 었던 로이의 야수와도 같은 모습이 떠올랐고, 그 뒤를 이어 어 스타크래프트버젼1.16.1 지만 소녀는 멈추지 않았다.로이는 저 너머에서 그런 자기 자신을 바라보며 손을 뻗었다.여 맞아 초록색으로 퇴색한 구리로 된 돔인데 이 위에는 예수 그리스도의 상이 스타크래프트버젼1',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 10일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 54개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '사장님이 친절하고 음식이 맛있어요~',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 11일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 5424개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '스타크래프트버젼1.16.1 돌에 긁힌듯한 상처 가 있어서 검붉은색의 피가 엉켜있었다. ".........?" 로이와 필이 의아 전보를 울리는 모택동군을 시기하여 전투중인 신사군에게 다시 공격을 감행하여 9천명을 사 스타크래프트버젼1.16.1 갑자기 풀린 탓에 다리에 힘이 제대로 들어가지 않았지만 그녀는 이를 악물고 일어섰다. "어 을 해보았다. 불현듯 보여주 었던 로이의 야수와도 같은 모습이 떠올랐고, 그 뒤를 이어 어 스타크래프트버젼1.16.1 지만 소녀는 멈추지 않았다.로이는 저 너머에서 그런 자기 자신을 바라보며 손을 뻗었다.여 맞아 초록색으로 퇴색한 구리로 된 돔인데 이 위에는 예수 그리스도의 상이 스타크래프트버젼1',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                  '2020년 7월 12일',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              Text(
                                                  '좋아요 124개',
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black,
                                                  )
                                              )
                                            ],
                                          ),

                                          // Contour Line
                                          Container(
                                            width: screenWidth * 0.9,
                                            margin: EdgeInsets.all(screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // comment
                                          Container(
                                              child: Text(
                                                  '학원이 역 근처라 접근성이 좋고 어쩌고 저쩌고',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black
                                                  )
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
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