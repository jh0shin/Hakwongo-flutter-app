import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hwgo/academyinfo.dart';
import 'package:hwgo/settings.dart';

// user info bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';

// rest api request
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {

  // TODO : 회원 탈퇴 기능 추가
  
  // logged in user information
  String _loginUser = '';

  // offset
  int _bookmarkOffset = 0;
  int _commentOffset = 0;
  int _testOffset = 0;
  int _limit = 3;

  // whether item left
  bool _isBookmarkLeft = true;
  bool _isCommentLeft = true;
  bool _isTestLeft = true;

  // shared preferences
  SharedPreferences _pref;

  // bookmark and comment list
  List<AcademyInfo> _bookmarkedAcademy = [];
  List<BookmarkedAcademy> _myBookmark = [];
  List<BookmarkedAcademy> _myBookmarkBuffer = [];
  List<AcademyComment> _myComment = [];
  List<AcademyComment> _myCommentBuffer = [];
  List<RecentTest> _myTest = [];
  List<RecentTest> _myTestBuffer = [];

  // get user's test
  void _getMyTest() async {
    final response = await http.post(
      'https://hakwongo.com:2052/api2/test/recent',
      body: {
        'user' : _loginUser,
        'limit' : _limit.toString(),
        'offset' : _testOffset.toString()
      }
    );

    print(response.body);

    final List<RecentTest> parsedMyTest = jsonDecode(response.body)
      .map<RecentTest>((json) => RecentTest.fromJSON(json))
      .toList();
    setState(() {
      _myTest.clear();
      _myTest.addAll(parsedMyTest);
    });
  }

  // get user's more comment
  void _getMoreMyTest() async {
    _testOffset += _limit;

    final response = await http.post(
        'https://hakwongo.com:2052/api2/test/recent',
        body: {
          'user' : _loginUser,
          'limit' : _limit.toString(),
          'offset' : _testOffset.toString(),
        }
    );

    if (response.body == '[]') {
      setState(() {
        _myTestBuffer.clear();
        _isTestLeft = false;
      });
    } else {
      final List<RecentTest> parsedMyTest = jsonDecode(response.body)
          .map<RecentTest>((json) => RecentTest.fromJSON(json))
          .toList();
      setState(() {
        _myTestBuffer.clear();
        _myTestBuffer.addAll(parsedMyTest);
      });
    }
  }

  // get user's comment
  void _getMyComment() async {
    final response = await http.post(
      'https://hakwongo.com:2052/api2/comment/my',
      body: {
        'user' : _loginUser,
        'limit' : _limit.toString(),
        'offset' : _commentOffset.toString(),
      }
    );

    final List<AcademyComment> parsedMyComment = jsonDecode(response.body)
      .map<AcademyComment>((json) => AcademyComment.fromJSON(json))
      .toList();
    setState(() {
      _myComment.clear();
      _myComment.addAll(parsedMyComment);
    });
  }

  // get user's more comment
  void _getMoreMyComment() async {
    _commentOffset += _limit;

    final response = await http.post(
      'https://hakwongo.com:2052/api2/comment/my',
      body: {
        'user' : _loginUser,
        'limit' : _limit.toString(),
        'offset' : _commentOffset.toString(),
      }
    );

    if (response.body == '[]') {
      setState(() {
        _myCommentBuffer.clear();
        _isCommentLeft = false;
      });
    } else {
      final List<AcademyComment> parsedMyComment = jsonDecode(response.body)
          .map<AcademyComment>((json) => AcademyComment.fromJSON(json))
          .toList();
      setState(() {
        _myCommentBuffer.clear();
        _myCommentBuffer.addAll(parsedMyComment);
      });
    }
  }

  // get user's bookmark list
  void _getMyBookmark() async {
    final response = await http.post(
      'https://hakwongo.com:2052/api2/bookmark/my',
      body: {
        'user' : _loginUser,
        'limit' : _limit.toString(),
        'offset' : _bookmarkOffset.toString(),
      }
    );

    final List<BookmarkedAcademy> parsedMyAcademy = jsonDecode(response.body)
      .map<BookmarkedAcademy>((json) => BookmarkedAcademy.fromJSON(json))
      .toList();
    _myBookmark.clear();
    _myBookmark.addAll(parsedMyAcademy);

    setState(() {
      _bookmarkedAcademy.clear();
      _myBookmark.forEach((bookmark) => _generateBookmarkList(bookmark));
    });
  }

  // get user's bookmark list more
  void _getMoreBookmark() async {
    _bookmarkOffset += _limit;

    final response = await http.post(
      'https://hakwongo.com:2052/api2/bookmark/my',
      body: {
        'user' : _loginUser,
        'limit' : _limit.toString(),
        'offset' : _bookmarkOffset.toString(),
      }
    );

    if (response.body == '[]') {
      setState(() {
        _myBookmarkBuffer.clear();
        _isBookmarkLeft = false;
      });
    } else {
      final List<BookmarkedAcademy> parsedMyAcademy = jsonDecode(response.body)
          .map<BookmarkedAcademy>((json) => BookmarkedAcademy.fromJSON(json))
          .toList();
      _myBookmarkBuffer.clear();
      _myBookmarkBuffer.addAll(parsedMyAcademy);

//      setState(() {
//        _myBookmark.forEach((bookmark) => _generateBookmarkList(bookmark));
//      });
    }
  }

  // add _bookmarkedAcademy from _myBookmark info
  void _generateBookmarkList(BookmarkedAcademy bookmark) async {
    final response = await http.post(
      'https://hakwongo.com:2052/api2/search/corona/id',
      body: {
        'id' : bookmark.id.toString(),
      }
    );
    final List<AcademyInfo> parsedAcademyInfo = jsonDecode(response.body)
      .map<AcademyInfo>((json) => AcademyInfo.fromJSON(json))
      .toList();

    setState(() {
      _bookmarkedAcademy.add(parsedAcademyInfo[0]);
    });
  }

  // academy button clicked -> goto academy info page
  void _academyClicked(AcademyInfo _selectedAcademy) {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => AcademyInfoPage(_selectedAcademy)
      )
    ).then((value) {
      initState();
    });
  }

  // comment button clicked -> goto comment's academy info page
  void _commentClicked(int academyID) async {
    final response = await http.post(
        'https://hakwongo.com:2052/api2/search/corona/id',
        body: {
          'id' : academyID.toString(),
        }
    );
    final List<AcademyInfo> parsedAcademyInfo = jsonDecode(response.body)
        .map<AcademyInfo>((json) => AcademyInfo.fromJSON(json))
        .toList();

    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => AcademyInfoPage(parsedAcademyInfo[0])
      )
    ).then(
      (value) {
        print(_loginUser);
        print(_limit);
        print(_commentOffset);
        _getMyComment();
      }
    );
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

//  void _checkUser () async {
//    _pref = await SharedPreferences.getInstance();
//    _loginUser = _pref.getString('apple') ?? BlocProvider.of<UserBloc>(context).currentState.toString()
//        .split(",")[0].split(": ")[1];
//
//    _getMyBookmark();
//    _getMoreBookmark();
//    _getMyComment();
//    _getMoreMyComment();
//    _getMyTest();
//    _getMoreMyTest();
//
//    print(_loginUser);
//  }

  @override
  void initState() {
    super.initState();

    // _checkUser();
    try {
      _loginUser = BlocProvider.of<UserBloc>(context).currentState.toString()
          .split(",")[0].split(": ")[1];
    } catch(e) {
      _loginUser = '비회원';
    }

    _getMyBookmark();
    _getMoreBookmark();
    _getMyComment();
    _getMoreMyComment();
    _getMyTest();
    _getMoreMyTest();
  }
  /*
  TODO : 내가 쓴 댓글에서 클릭하여 학원 페이지로 넘어갔다가 댓글 작성 후
  다시 돌아오면 내가 쓴 댓글에 바로 반영이 안되는 오류가 있음
  setState로 설정을 해봤는데도 같아서 아예 페이지 자체를 새로 시작해서
  initState에서 댓글을 api요청으로 다시 받아오는 방법이 필요함.

   */

  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      double screenWidth = MediaQuery.of(context).size.width;                   // screen width
      final bloc = BlocProvider.of<UserBloc>(context);                          // bloc for get user information
      var _user;

      if (state is UserFetched) { // successfully logged in
        _user = state.user;

        if (_loginUser == '') {
          _loginUser = _user.id.toString();
        }


      }
//      else { // not logged in case
//        return Container(
//          child: Center(
//            child: Text("NoMatchUserError")
//          )
//        );
//      }

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
                                              backgroundImage: _loginUser == '비회원'
                                                ? AssetImage("assets/image/logo.png")
                                                : (_user.properties.containsKey("profile_image")
                                                  ? NetworkImage(_user.properties["profile_image"])
                                                  : AssetImage("assets/image/logo.png")),
//                                              backgroundImage: AssetImage("assets/image/logo.png"),
                                            ),
                                          ),

                                          // profile nickname
                                          Flexible(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    _loginUser == '비회원'
                                                      ? '비회원'
                                                      : _user.properties["nickname"],
                                                    style: TextStyle(
                                                      fontFamily: 'dream3',
                                                      fontSize: screenWidth * 0.05,
                                                      letterSpacing: -2,
                                                      color: Colors.black,
                                                    )
                                                ),
                                              )
                                          ),

                                          // login & logout button
                                          Flexible(
                                              flex: 1,
                                              child: _loginUser == '비회원'
                                                ? RawMaterialButton(
                                                  onPressed: (){
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
                                                            "로그인",
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
                                                : RawMaterialButton(
                                                  onPressed: (){
                                                    bloc.dispatch(UserLogOut());
                                                    Navigator.of(context).pushReplacementNamed("/");
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

                                            _loginUser == '비회원'
                                              ? Container(
                                              child: Center(
                                                child: Text(
                                                    "로그인 후 이용할 수 있는 기능입니다.",
                                                    style: TextStyle(
                                                      fontFamily: 'dream3',
                                                      fontSize: screenWidth * 0.05,
                                                      letterSpacing: -2,
                                                      color: Colors.black,
                                                    )
                                                )
                                              )
                                            )
                                              : Container()
                                          ]

                                              // my bookmarked academy
                                              + List.generate(_bookmarkedAcademy.length, (index) {
                                                return SizedBox(
                                                    width: screenWidth * 0.9,
                                                    height: screenWidth * 0.2,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: <Widget>[
                                                        RawMaterialButton(
                                                          onPressed: () => _academyClicked(_bookmarkedAcademy[index]),
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
                                                                              _bookmarkedAcademy[index].name,
                                                                              style: TextStyle(
                                                                                fontFamily: 'dream5',
                                                                                fontSize: screenWidth * 0.055,
                                                                                letterSpacing: -2,
                                                                                color: Colors.black,
                                                                              )
                                                                          ),

                                                                          // 학원 주소
                                                                          Text(
                                                                              _bookmarkedAcademy[index].addr,
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
                                                _isBookmarkLeft
                                                    ? SizedBox(
                                                    width: screenWidth * 0.9,
                                                    height: screenWidth * 0.1,
                                                    child: RawMaterialButton(
                                                      onPressed: () {
                                                        if (_myBookmarkBuffer.length != 0) {
                                                          setState(() {
                                                            _myBookmarkBuffer.forEach((bookmark) => _generateBookmarkList(bookmark));
                                                          });
                                                          _getMoreBookmark();
                                                        }
                                                      },
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
                                                )
                                                    : SizedBox(),
                                              ]
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

                                          _loginUser == '비회원'
                                              ? Container(
                                              child: Center(
                                                  child: Text(
                                                      "로그인 후 이용할 수 있는 기능입니다.",
                                                      style: TextStyle(
                                                        fontFamily: 'dream3',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                              )
                                          )
                                              : Container()
                                        ]

                                            + List.generate(_myComment.length, (index) {
                                              return SizedBox(
                                                width: screenWidth,
                                                child: Container(
                                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                                  margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                                  color: commentcolor,
                                                  child: RawMaterialButton(
                                                      onPressed: () => _commentClicked(_myComment[index].id),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          // time and like information, delete and like button
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              // time
                                                              Text(
                                                                  _myComment[index].time,
                                                                  style: TextStyle(
                                                                    fontFamily: 'dream4',
                                                                    fontSize: screenWidth * 0.04,
                                                                    letterSpacing: -1,
                                                                    color: Colors.black45,
                                                                  )
                                                              ),

                                                              // padding
                                                              SizedBox(width: screenWidth * 0.2),

                                                              // like
                                                              SizedBox(
                                                                  width: screenWidth * 0.25,
                                                                  height: screenWidth * 0.04,
                                                                  child: Container(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Text(
                                                                          '좋아요 ' + _myComment[index].heart.toString() + '개',
                                                                          style: TextStyle(
                                                                            fontFamily: 'dream4',
                                                                            fontSize: screenWidth * 0.04,
                                                                            letterSpacing: -1,
                                                                            color: Colors.black,
                                                                          )
                                                                      )
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
                                                                  _myComment[index].comment,
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
                                                      )
                                                  ),
                                                ),
                                              );
                                            })

                                            + [
                                              // show more button
                                              _isCommentLeft
                                                  ? SizedBox(
                                                  width: screenWidth * 0.9,
                                                  height: screenWidth * 0.1,
                                                  child: RawMaterialButton(
                                                    onPressed: (){
                                                      if (_myCommentBuffer.length != 0) {
                                                        setState(() {
                                                          _myComment.addAll(_myCommentBuffer);
                                                        });
                                                        _getMoreMyComment();
                                                      }
                                                    },
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
                                              )
                                                  : SizedBox(),
                                            ],
                                      )
                                  ),
                                ),

//                                  // Contour line
//                                  Container(
//                                    width: screenWidth * 0.9,
//                                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//                                    decoration: BoxDecoration(
//                                      border: Border.all(width: 0.5, color: Colors.black45),
//                                    ),
//                                  ),
//
//                                  // my learning test
//                                  SizedBox(
//                                    width: screenWidth,
//                                    child: Container(
//                                        padding: EdgeInsets.all(screenWidth * 0.02),
//                                        child: Column(
//                                          children: <Widget>[
//                                            // Title - liked Academy
//                                            Container(
//                                              alignment: Alignment.centerLeft,
//                                              padding: EdgeInsets.all(screenWidth * 0.02),
//                                              child: Text(
//                                                  "내 학습성향검사",
//                                                  style: TextStyle(
//                                                    fontFamily: 'dream5',
//                                                    fontSize: screenWidth * 0.06,
//                                                    letterSpacing: -2,
//                                                    color: Colors.black,
//                                                  )
//                                              ),
//                                            ),
//                                          ]
//
//                                              + List.generate(_myTest.length, (index) {
//                                                return SizedBox(
//                                                  width: screenWidth,
//                                                  child: Container(
//                                                    padding: EdgeInsets.all(screenWidth * 0.02),
//                                                    margin: EdgeInsets.only(bottom: screenWidth * 0.02),
//                                                    color: commentcolor,
//                                                    child: RawMaterialButton(
//                                                        onPressed: () { /* TODO : Add action */ },
//                                                        child: Column(
//                                                          crossAxisAlignment: CrossAxisAlignment.start,
//                                                          children: <Widget>[
//                                                            // time and like information, delete and like button
//                                                            Row(
//                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                              children: <Widget>[
//                                                                // time
//                                                                Text(
//                                                                    _myTest[index].testtime + '에 시행한 검사',
//                                                                    style: TextStyle(
//                                                                      fontFamily: 'dream4',
//                                                                      fontSize: screenWidth * 0.04,
//                                                                      letterSpacing: -1,
//                                                                      color: Colors.black45,
//                                                                    )
//                                                                ),
//                                                              ],
//                                                            ),
//                                                          ],
//                                                        )
//                                                    ),
//                                                  ),
//                                                );
//                                              })
//
//                                              + [
//                                                // show more button
//                                                _isTestLeft
//                                                    ? SizedBox(
//                                                    width: screenWidth * 0.9,
//                                                    height: screenWidth * 0.1,
//                                                    child: RawMaterialButton(
//                                                      onPressed: (){
//                                                        if (_myTestBuffer.length != 0) {
//                                                          setState(() {
//                                                            _myTest.addAll(_myTestBuffer);
//                                                          });
//                                                          _getMoreMyTest();
//                                                        }
//                                                      },
//                                                      child: Container(
//                                                        alignment: Alignment.center,
//                                                        width: screenWidth * 0.9,
//                                                        padding: EdgeInsets.all(screenWidth * 0.02),
//                                                        child: Text(
//                                                            "내 학습성향검사 더보기",
//                                                            style: TextStyle(
//                                                              fontFamily: 'dream4',
//                                                              fontSize: screenWidth * 0.05,
//                                                              letterSpacing: -2,
//                                                              color: Colors.black,
//                                                            )
//                                                        ),
//                                                      ),
//                                                    )
//                                                )
//                                                    : SizedBox(),
//                                              ],
//                                        )
//                                    ),
//                                  ),

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


    },
  );
}