import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hwgo/settings.dart';
import 'package:hwgo/academycomment.dart';

// user info bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/userbloc.dart';

// rest api request
import 'package:http/http.dart' as http;
import 'dart:convert';

// kakao map
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:io';
import 'package:flutter_appavailability/flutter_appavailability.dart';

// for phone call
import 'package:url_launcher/url_launcher.dart';

class AcademyInfoPage extends StatefulWidget {
  // Selected academy
  AcademyInfo _currentAcademy;

  // constructor
  AcademyInfoPage(this._currentAcademy);

  @override
  _AcademyInfoPageState createState() => _AcademyInfoPageState();
}

class _AcademyInfoPageState extends State<AcademyInfoPage> {

  // KAKAO Rest API Key
  String _restAPIKey = "KakaoAK fe1e959f4430ca6e14a8c92aa63ce6b7";

  // user information
  String _currentUser;

  // selected academy's coordinate
  String _xCoordinate = '';
  String _yCoordinate = '';

  // WCONGNAMUL coordinate
  String _xTransCoord = '';
  String _yTransCoord = '';

  // comment input
  String _commentInput = '';

  // class information list
  List<AcademyClass> _classInfo = [];

  // academy comment list
  List<AcademyComment> _academyComment = [];

  // academy comment count
  int _commentCount = 0;

  // like for comment
  void _likeComment(AcademyComment cmt) async {
    final response = await http.post(
        'http://hakwongo.com:3000/api2/comment/like',
        body: {
          'id' : cmt.id.toString(),
          'user' : cmt.user,
          'time' : cmt.time,
          'comment' : cmt.comment,
        }
    );
    setState(() {
      _getComment();
      _getCommentNum();
    });
  }

  // delete comment
  void _deleteComment(AcademyComment del) async {
    final response = await http.post(
        'http://hakwongo.com:3000/api2/comment/delete',
        body: {
          'id' : del.id.toString(),
          'user' : del.user,
          'time' : del.time,
          'comment' : del.comment,
        }
    );
    setState(() {
      _getComment();
      _getCommentNum();
    });
  }

  // get number of comment of academy
  void _getCommentNum() async {
    final response = await http.post(
        'http://hakwongo.com:3000/api2/comment/num',
        body: {
          'id' : widget._currentAcademy.id.toString(),
        }
    );
    setState(() {
      _commentCount = int.parse(response.body.split(':')[1].split('}')[0]);
    });
  }

  // post comment
  void _postComment() async {
    // hide soft keyboard
    FocusScope.of(context).requestFocus(new FocusNode());

    if (_commentInput == '') {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            double screenWidth = MediaQuery.of(context).size.width;

            return Center(
                child: SizedBox(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.4,
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
                          SizedBox(height: screenWidth * 0.08),

                          // phone number
                          Material(
                              child: Container(
                                  color: Colors.white,
                                  child: Text(
                                      "댓글을 입력해주세요.",
                                      style: TextStyle(
                                          fontFamily: 'dream4',
                                          fontSize: screenWidth * 0.05,
                                          letterSpacing: -2,
                                          color: Colors.black
                                      )
                                  )
                              )
                          ),

                          // space
                          SizedBox(height: screenWidth * 0.08),

                          // button
                          // call
                          RawMaterialButton(
                            onPressed: (){
                              // TODO : create calling method
                              Navigator.pop(context);
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
                                      "확인",
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
                      )
                  ),
                )
            );
          }
      );
    } else {
      await http.post(
          'http://hakwongo.com:3000/api2/comment/post',
          body: {
            'id' : widget._currentAcademy.id.toString(),
            'user' : _currentUser,
            'time' : DateTime.now().toString().split('.')[0],
            'comment' : _commentInput,
          }
      );
      setState(() {
        _getComment();
        _getCommentNum();
      });
    }
  }

  // get comment list
  void _getComment() async {
    final response = await http.post(
      'http://hakwongo.com:3000/api2/comment/get',
      body: {
        'id' : widget._currentAcademy.id.toString(),
        'limit' : '3',
        'offset' : '0',
        'order' : 'heart',
      }
    );
    final List<AcademyComment> parsedAcademyComment = jsonDecode(response.body)
      .map<AcademyComment>((json) => AcademyComment.fromJSON(json))
      .toList();
    setState(() {
      _academyComment.clear();
      _academyComment.addAll(parsedAcademyComment);
    });
  }

  // get kakao map image
  void _showKakaoMap() {
    showDialog(
        context: context,
        builder: (BuildContext context) {

          print(_yCoordinate);
          print(_xCoordinate);

          return WebviewScaffold(
            withJavascript: true,
            enableAppScheme: true,
            geolocationEnabled: true,
            url: 'https://map.kakao.com/link/map/' + widget._currentAcademy.name + ',' + _yCoordinate +',' +_xCoordinate,
          );
        }
    );
  }

  // kakao api address -> coordinate (WGS84)
  void _addressToCoordinate() async {
    var _addstr = '';
    if(widget._currentAcademy.addr.contains('로 ') == true) {
      _addstr = widget._currentAcademy.addr.split('로 ')[0] + '로 ' + widget._currentAcademy.addr.split('로 ')[1].split(' ')[0];
    }
    else {
      _addstr = widget._currentAcademy.addr.split('길 ')[0] + '길 ' + widget._currentAcademy.addr.split('길 ')[1].split(' ')[0];
    }
    final response = await http.get(
        'http://dapi.kakao.com/v2/local/search/address.json?query=' + _addstr,
        headers: {
          "Authorization": _restAPIKey,
        }
    );
    print(response.body);

    var _jsonDecodeData = jsonDecode(response.body)['documents'][0];

    _xCoordinate = _jsonDecodeData['x'];
    _yCoordinate = _jsonDecodeData['y'];

    _transCoord();
  }

  // kakao api coordinate(WGS84) -> coordinate(WCONGNAMUL)
  void _transCoord() async {
    final response2 = await http.get(
        'http://dapi.kakao.com/v2/local/geo/transcoord.json?x=' + _xCoordinate + '&y=' + _yCoordinate + '&output_coord=WCONGNAMUL',
        headers: {
          "Authorization": _restAPIKey,
        }
    );
    var _jsonDecodeData = jsonDecode(response2.body)['documents'][0];

    setState(() {
      _xTransCoord = _jsonDecodeData['x'].toInt().toString();
      _yTransCoord = _jsonDecodeData['y'].toInt().toString();
    });
  }

  // get academy class information
  void _getClassInfo() async {
    final response = await http.post(
      'http://hakwongo.com:3000/api2/classinfo',
      body: {
        'id' : widget._currentAcademy.id.toString(),
      }
    );
    if (response.body != null) {
      final List<AcademyClass> parsedSearchResult = jsonDecode(response.body)
          .map<AcademyClass>((json) => AcademyClass.fromJSON(json))
          .toList();
      setState(() {
         _classInfo.clear();
         _classInfo.addAll(parsedSearchResult);
      });
    }
  }

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
                          height: screenWidth * 0.1,
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
                          Navigator.pop(context);
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
    _getClassInfo();
    _getComment();
    _getCommentNum();

    // http request for get map coordinate
    _xCoordinate = '';
    _yCoordinate = '';
    _xTransCoord = '';
    _yTransCoord = '';
    _addressToCoordinate();

    // TODO : check if academy information is ready
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        double screenWidth = MediaQuery.of(context).size.width;

        if (state is UserFetched) {
          _currentUser = state.user.id.toString();
        }

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
                                          child: Text(
                                            widget._currentAcademy.name,
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
                                      child: FlatButton(
                                        onPressed: () {
                                          _showKakaoMap();
                                          final webView = new FlutterWebviewPlugin();
                                          webView.onUrlChanged.listen((String url) async {
                                            if (mounted && !(url.contains('http'))) {
                                              url = 'daummaps://look?p=' + _yCoordinate + ',' + _xCoordinate;

                                              // 카카오맵 깔려있나 확인 후 깔려있으면 그대로, 안깔려있으면 플레이스토어로 연결.
                                              if (Platform.isAndroid) {
                                                try {
                                                  // check if app is enabled
                                                  // if PlatformException occur, goto playstore install page
                                                  await AppAvailability.isAppEnabled('net.daum.android.map');

                                                  // no PlatformException occured
                                                  if (await canLaunch(url)) {
                                                    Navigator.pop(context);
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }
                                                } on PlatformException {
                                                  Navigator.pop(context);
                                                  await launch('https://play.google.com/store/apps/details?id=net.daum.android.map&hl=ko');
                                                }
                                              }
                                              // TODO: ADD PLATFORM == IOS CASE
                                            }
                                          });
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Image.network(
                                              'https://map2.daum.net/map/mapservice?FORMAT=PNG&SCALE=2.5&MX='+_xTransCoord
                                                  +'&MY='+_yTransCoord
                                                  +'&S=0&IW='+(screenWidth * 0.9 * 1.25).toInt().toString()
                                                  +'&IH='+(screenWidth * 0.5 * 1.25).toInt().toString()
                                                  +'&LANG=0&COORDSTM=WCONGNAMUL&logo=kakao_logo',
                                              width: screenWidth,
                                            ),

                                            // Marker for exact place
                                            Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    size: screenWidth * 0.1,
                                                    color: Colors.blue,
                                                  ),

                                                  // paddiing for align icon
                                                  Container(
                                                    height: screenWidth * 0.1,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
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
                                                widget._currentAcademy.addr,
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
                                    margin: EdgeInsets.only(bottom: screenWidth * 0.02),
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
                                            widget._currentAcademy.name,
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
                                              '설립자 : ' + widget._currentAcademy.founder,
                                              style: TextStyle(
                                                fontFamily: 'dream3',
                                                fontSize: screenWidth * 0.04,
                                                letterSpacing: -1,
                                                color: Colors.black,
                                              )
                                          ),

                                          // phone number
                                          Text(
                                              '전화번호 : ' + widget._currentAcademy.callnum,
                                              style: TextStyle(
                                                fontFamily: 'dream3',
                                                fontSize: screenWidth * 0.04,
                                                letterSpacing: -1,
                                                color: Colors.black,
                                              )
                                          ),

                                          // padding
                                          SizedBox(height: screenWidth * 0.02),

                                          // class information title
                                          Text(
                                              '강의 정보',
                                              style: TextStyle(
                                                fontFamily: 'dream5',
                                                fontSize: screenWidth * 0.05,
                                                letterSpacing: -1,
                                                color: Colors.black,
                                              )
                                          ),

                                          // padding
                                          SizedBox(height: screenWidth * 0.02),
                                        ]
                                        // class information
                                        + List.generate(_classInfo.length, (index) {
                                          AcademyClass tmp = _classInfo[index];

                                          return Text(
                                            tmp.classname + ',' + tmp.age + ',' + tmp.size + ',' + tmp.time + ','
                                                + tmp.totaltime + ',' + tmp.cost1 + ',' + tmp.cost2 + ',' + tmp.cost3
                                                + ',' + tmp.cost4 + ',' + tmp.cost5 + ',' + tmp.cost6 + ',' + tmp.cost7
                                                + ',' + tmp.teacher,
                                            style: TextStyle(
                                              fontFamily: 'dream3',
                                              fontSize: screenWidth * 0.04,
                                              letterSpacing: -1,
                                              color: Colors.black,
                                            )
                                          );
                                            }),
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

                                  // comment title and number of comment, submit button
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
                                                      '( ' +_commentCount.toString() + ' )',
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
                                                        builder: (context) => AcademyCommentPage(widget._currentAcademy)
                                                      ),
                                                    ).then((value) {
                                                      setState(() {
                                                        _getCommentNum();
                                                        _getComment();
                                                      });
                                                    });
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
                                                      onPressed: _postComment,
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
                                ]
                                // comment get from server
                                + List.generate(_academyComment.length, (index) {
                                  return SizedBox(
                                    width: screenWidth,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                                      color: commentcolor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // time and like information, delete and like button
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              // time
                                              Text(
                                                  _academyComment[index].time,
                                                  style: TextStyle(
                                                    fontFamily: 'dream4',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.black45,
                                                  )
                                              ),

                                              // padding
                                              SizedBox(width: screenWidth * 0.1),

                                              // delete
                                              _currentUser == _academyComment[index].user
                                                ? SizedBox(
                                                  width: screenWidth * 0.08,
                                                  height: screenWidth * 0.04,
                                                  child: RawMaterialButton(
                                                      onPressed: () => _deleteComment(_academyComment[index]),
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: screenWidth * 0.04,
                                                      )
                                                  )
                                                )
                                                : SizedBox(
                                                  width: screenWidth * 0.08,
                                                  height: screenWidth * 0.04,
                                                ),

                                              // like
                                              SizedBox(
                                                  width: screenWidth * 0.08,
                                                  height: screenWidth * 0.04,
                                                  child: RawMaterialButton(
                                                      onPressed: () => _likeComment(_academyComment[index]),
                                                      child: Icon(
                                                        Icons.favorite,
                                                        size: screenWidth * 0.04,
                                                        color: Colors.red
                                                      )
                                                  )
                                              ),

                                              // like
                                              Text(
                                                  '좋아요 ' + _academyComment[index].heart.toString() + '개',
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
                                                  _academyComment[index].comment,
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
                                  );
                                }),
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