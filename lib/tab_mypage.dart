import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';

import 'package:hwgo/settings.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {

  String _loginUser = '';                                                       // logged in user information

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

  @override
  void initState() {
    super.initState();

    // get logged in user id from UserBloc
    _loginUser = BlocProvider.of<UserBloc>(context).currentState.toString()
        .split(",")[0].split(": ")[1];
  }

  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      double screenWidth = MediaQuery.of(context).size.width;                   // screen width
      final bloc = BlocProvider.of<UserBloc>(context);                          // bloc for get user information

      if (state is UserFetched) { // successfully logged in
        final _user = state.user;

        if (_loginUser == '') {
          _loginUser = _user.id.toString();
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
                          SizedBox(
                              width: screenWidth,
                              height: screenWidth * 0.15,
                              child: Container(
                                  color: bgcolor,
                                  child: Center(
                                    child: Text("마이페이지",
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

                                  // account info
                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // profile image
                                          Flexible(
                                            flex: 1,
                                            child: CircleAvatar(
                                              radius: screenWidth * 0.07,
                                              backgroundImage: _user.properties.containsKey("profile_image")
                                                  ? NetworkImage(_user.properties["profile_image"])
                                                  : AssetImage("assets/image/logo.png"),
                                            ),
                                          ),

                                          // profile nickname
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                _user.properties["nickname"],
                                                style: TextStyle(
                                                  fontFamily: 'dream3',
                                                  fontSize: screenWidth * 0.05,
                                                  letterSpacing: -2,
                                                  color: Colors.black,
                                                )
                                              ),
                                            )
                                          ),

                                          // logout button
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              onPressed: (){
                                                bloc.dispatch(UserLogOut());
                                                Navigator.of(context).pushReplacementNamed("/login");
                                              },
                                              child: Container(
                                                width: screenWidth * 0.2,
                                                height: screenWidth * 0.1,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.black45,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "로그아웃",
                                                    style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -2,
                                                      color: Colors.white,
                                                    )
                                                  )
                                                ),
                                              )
                                            )
                                          )
                                        ],
                                      )
                                    ),
                                  ),

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
                                        children: <Widget>[
                                          // Title - liked Academy
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.all(screenWidth * 0.02),
                                            child: Text(
                                                "내가 찜한 학원",
                                                style: TextStyle(
                                                  fontFamily: 'dream5',
                                                  fontSize: screenWidth * 0.06,
                                                  letterSpacing: -2,
                                                  color: Colors.black,
                                                )
                                            ),
                                          ),

                                          // academy info(button)
                                          SizedBox(
                                              width: screenWidth * 0.9,
                                              height: screenWidth * 0.2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {},
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
                                                    onPressed: () {},
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

                                          // show more button
                                          SizedBox(
                                              width: screenWidth * 0.9,
                                              height: screenWidth * 0.1,
                                              child: RawMaterialButton(
                                                onPressed: () {},
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: screenWidth * 0.9,
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  child: Text(
                                                    "찜한 학원 더보기",
                                                    style: TextStyle(
                                                      fontFamily: 'dream4',
                                                      fontSize: screenWidth * 0.05,
                                                      letterSpacing: -2,
                                                      color: Colors.black,
                                                    )
                                                  ),
                                                ),
                                              )
                                          ),
                                        ],
                                      )
                                    ),
                                  ),

                                  // Contour line
                                  Container(
                                    width: screenWidth * 0.9,
                                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Colors.black45),
                                    ),
                                  ),

                                  // my comment
                                  SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                        padding: EdgeInsets.all(screenWidth * 0.02),
                                        child: Column(
                                          children: <Widget>[
                                            // Title - liked Academy
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.all(screenWidth * 0.02),
                                              child: Text(
                                                  "내가 쓴 댓글",
                                                  style: TextStyle(
                                                    fontFamily: 'dream5',
                                                    fontSize: screenWidth * 0.06,
                                                    letterSpacing: -2,
                                                    color: Colors.black,
                                                  )
                                              ),
                                            ),

                                            // exaple comment
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

                                            // exaple comment
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

                                            // show more button
                                            SizedBox(
                                                width: screenWidth * 0.9,
                                                height: screenWidth * 0.1,
                                                child: RawMaterialButton(
                                                  onPressed: () {},
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: screenWidth * 0.9,
                                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                                    child: Text(
                                                        "내가 쓴 댓글 더보기",
                                                        style: TextStyle(
                                                          fontFamily: 'dream4',
                                                          fontSize: screenWidth * 0.05,
                                                          letterSpacing: -2,
                                                          color: Colors.black,
                                                        )
                                                    ),
                                                  ),
                                                )
                                            ),
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
                  )
              )
          ),
        );
      } else { // not logged in case
        return Container(
          child: Center(
            child: Text("NoMatchUserError")
          )
        );
      }


    },
  );
}