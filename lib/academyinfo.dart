import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwgo/settings.dart';
import 'package:hwgo/academycomment.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/userbloc.dart';

// for phone call
import 'package:url_launcher/url_launcher.dart';

class AcademyInfoPage extends StatefulWidget {
  @override
  _AcademyInfoPageState createState() => _AcademyInfoPageState();
}

class _AcademyInfoPageState extends State<AcademyInfoPage> {

  // comment input
  String _commentInput = '';

  // calling button clicked
  void _callButtonClicked() {
    showDialog(
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

                  // phone number
                  Material(
                    child: Container(
                      color: Colors.white,
                      child: Text(
                          "010-4803-3704",
                          style: TextStyle(
                              fontFamily: 'dream3',
                              fontSize: screenWidth * 0.06,
                              letterSpacing: -1,
                              color: Colors.black
                          )
                      )
                    )
                  ),

                  // guide text
                  Material(
                    child: Container(
                      color: Colors.white,
                      child: Text(
                          "학원에 전화를 거시겠습니까?",
                          style: TextStyle(
                              fontFamily: 'dream3',
                              fontSize: screenWidth * 0.04,
                              letterSpacing: -1,
                              color: Colors.black45
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
                      // call
                      RawMaterialButton(
                        onPressed: (){
                          // TODO : create calling method
                          launch("tel://01048033704");
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          width: screenWidth * 0.325,
                          height: screenWidth * 0.075,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: bgcolor,
                            ),
                            child: Center(
                              child: Text(
                                  "전화걸기",
                                  style: TextStyle(
                                      fontFamily: 'dream4',
                                      fontSize: screenWidth * 0.04,
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
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          width: screenWidth * 0.325,
                          height: screenWidth * 0.075,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Colors.black45,
                            ),
                            child: Center(
                              child: Text(
                                  "취소",
                                  style: TextStyle(
                                      fontFamily: 'dream5',
                                      fontSize: screenWidth * 0.04,
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

                                  // academy information
                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // title
                                          Text(
                                            '이민수수수학학학학학학학학학학학학학학학원원',
                                            style: TextStyle(
                                              fontFamily: 'dream5',
                                              fontSize: screenWidth * 0.06,
                                              letterSpacing: -2,
                                              color: Colors.black,
                                            )
                                          ),

                                          // padding
                                          SizedBox(height: screenWidth * 0.02),

                                          // phone number
                                          Text(
                                              '전화번호 : 010-3382-5623',
                                              style: TextStyle(
                                                fontFamily: 'dream3',
                                                fontSize: screenWidth * 0.04,
                                                letterSpacing: -1,
                                                color: Colors.black,
                                              )
                                          ),

                                          // phone number
                                          Text(
                                              '주요 교습 과목 : 수학, 과학(물2)',
                                              style: TextStyle(
                                                fontFamily: 'dream3',
                                                fontSize: screenWidth * 0.04,
                                                letterSpacing: -1,
                                                color: Colors.black,
                                              )
                                          ),

                                          // additional information
                                          Text(
                                              'A나라와 B나라에는 각각의 변호사가 살고있었다.\n'
                                                  + 'A나라와 B나라에는 각각의 변호사가 살고있었다.\n'
                                                  + 'B나라와 C나라에는 각각의 변호사가 살고있었다.\n'
                                                  + 'C나라와 D나라에는 각각의 변호사가 살고있었다.\n'
                                                  + 'D나라와 E나라에는 각각의 변호사가 살고있었다.\n'
                                                  + 'E나라와 F나라에는 각각의 변호사가 살고있었다.\n'
                                                  + 'F나라와 G나라에는 각각의 변호사가 살고있었다.\n'
                                                  + 'G나라와 H나라에는 각각의 변호사가 살고있었다.\n',
                                              style: TextStyle(
                                                fontFamily: 'dream3',
                                                fontSize: screenWidth * 0.04,
                                                letterSpacing: -1,
                                                color: Colors.black,
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
                                    height: screenWidth * 0.375,
                                    child: Container(
                                      padding: EdgeInsets.only(top: screenWidth * 0.02),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // comment title and number of comment, see more btn
                                          Stack(
                                            children: <Widget>[
                                              // title
                                              Container(
                                                padding: EdgeInsets.only(top: screenWidth * 0.02),
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
                                                alignment: Alignment.topRight,
                                                child: RawMaterialButton(
                                                  onPressed: (){
                                                    Navigator.push(
                                                      context, MaterialPageRoute(
                                                        builder: (context) => AcademyCommentPage()
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    width: screenWidth * 0.2,
                                                    height: screenWidth * 0.1,
                                                    child: Center(
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
                                                ),
                                              )
                                            ],
                                          ),

                                          // comment write area
                                          Container(
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
                                                          fontSize: screenWidth * 0.035,
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

                          // call button
                          RawMaterialButton(
                            onPressed: _callButtonClicked,
                            child: SizedBox(
                                width: screenWidth * 0.75,
                                height: screenWidth * 0.15,
                                child: Container(
                                    color: bgcolor,
                                    child: Center(
                                      child: Text("전화 상담",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'dream5',
                                              fontSize: screenWidth * 0.06,
                                              letterSpacing: 2,
                                              color: Colors.white
                                          )
                                      ),
                                    )
                                )
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