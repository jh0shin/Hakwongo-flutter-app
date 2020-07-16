import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwgo/settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/userbloc.dart';

// rest api request
import 'package:http/http.dart' as http;
import 'dart:convert';


class AcademyCommentPage extends StatefulWidget {
  // Selected academy
  AcademyInfo _currentAcademy;

  // constructor
  AcademyCommentPage(this._currentAcademy);

  @override
  _AcademyCommentPageState createState() => _AcademyCommentPageState();
}

class _AcademyCommentPageState extends State<AcademyCommentPage> {

  // sort option ( default : like )
  String _sortOption = '인기 댓글 순';

  // user information
  String _currentUser;

  // academy comment list
  List<AcademyComment> _academyComment = [];

  // list offset and limit
  int _offset = 0;
  int _limit = 20;

  // whether comment left
  // TODO : comment buffer creation (case : no more comment left, but button is clickable)
  bool _isCommentLeft = true;

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
    });
  }

  // get comment list
  void _getComment() async {
    final response = await http.post(
        'http://hakwongo.com:3000/api2/comment/get',
        body: {
          'id' : widget._currentAcademy.id.toString(),
          'limit' : _limit.toString(),
          'offset' : _offset.toString(),
          'order' : _sortOption == '인기 댓글 순'
            ? 'heart'
            : 'time',
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

  // get comment list
  void _getMoreComment() async {
    _offset += _limit;
    final response = await http.post(
        'http://hakwongo.com:3000/api2/comment/get',
        body: {
          'id' : widget._currentAcademy.id.toString(),
          'limit' : _limit.toString(),
          'offset' : _offset.toString(),
          'order' : _sortOption == '인기 댓글 순'
            ? 'heart'
            : 'time',
        }
    );
    if (response.body == '[]') {  // no more data
      setState(() {
        _isCommentLeft = false;
      });
    } else {
      final List<AcademyComment> parsedAcademyComment = jsonDecode(response.body)
          .map<AcademyComment>((json) => AcademyComment.fromJSON(json))
          .toList();
      setState(() {
        _academyComment.addAll(parsedAcademyComment);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getComment();
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
                                  // upper bar (sort option)
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
                                                    _offset = 0;
                                                    _isCommentLeft = true;
                                                    _getComment();
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
                                  })

                                  // additional result
                                + [
                                  _isCommentLeft
                                      ? SizedBox(
                                      width: screenWidth * 0.9,
                                      height: screenWidth * 0.15,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RawMaterialButton(
                                            onPressed: _getMoreComment,
                                            child: Container(
                                                width: screenWidth * 0.9,
                                                child: Center(
                                                    child: Text(
                                                        '댓글 더 보기',
                                                        style: TextStyle(
                                                          fontFamily: 'dream5',
                                                          fontSize: screenWidth * 0.055,
                                                          letterSpacing: -2,
                                                          color: Colors.black,
                                                        )
                                                    )
                                                )
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                                      : Container()
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