import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwgo/settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hwgo/bloc/userbloc.dart';
import 'package:hwgo/academyinfo.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  // search condition
  // access by widget.(variable name)
  String _selectedSido;
  String _selectedGungu;
  String _selectedDong;
  String _selectedSubject;
  String _selectedAge;

  // constructor
  SearchPage(this._selectedSido, this._selectedGungu, this._selectedDong,
      this._selectedSubject, this._selectedAge);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  // search result
  List<AcademyInfo> _searchResult = [];
  List<AcademyInfo> _searchResultBuffer = [];

  // search result offset
  int _offset = 0;
  int _limit = 10;
  bool _moreResultLeft = true;

  // post http request for given conditions
  void _getSearchResult() async {
    final response = await http.post(
      'http://hakwongo.com:3000/api2/search/init',
      body: {
        'limit' : _limit.toString(),
        'offset' : _offset.toString(),
        'sido' : widget._selectedSido,
        'gungu' : widget._selectedGungu,
        'dong' : widget._selectedDong,
        'subject' : widget._selectedSubject,
        'age' : widget._selectedAge,
      },
    );
    print(response.body);
    if (response.body != null) {
      final List<AcademyInfo> parsedSearchResult = jsonDecode(response.body)
          .map<AcademyInfo>((json) => AcademyInfo.fromJSON(json))
          .toList();
      setState(() {
        _searchResult.clear();
        _searchResult.addAll(parsedSearchResult);
      });
    }
  }

  // get more search result
  void _getMoreSearchResult() async {
    _offset += 1;

    final response = await http.post(
      'http://hakwongo.com:3000/api2/search/init',
      body: {
        'limit' : _limit.toString(),
        'offset' : (_offset * _limit).toString(),
        'sido' : widget._selectedSido,
        'gungu' : widget._selectedGungu,
        'dong' : widget._selectedDong,
        'subject' : widget._selectedSubject,
        'age' : widget._selectedAge,
      }
    );
    print(response.body);
    if (response.body == '[]') {  // no more data
      setState(() {
        _searchResultBuffer.clear();
        _moreResultLeft = false;
      });
    } else {                      // more data exists
      final List<AcademyInfo> parsedSearchResult = jsonDecode(response.body)
          .map<AcademyInfo>((json) => AcademyInfo.fromJSON(json))
          .toList();
      setState(() {
        _searchResultBuffer.clear();
        _searchResultBuffer.addAll(parsedSearchResult);
      });
    }
  }

  // academy button clicked -> goto academy info page
  void _academyClicked(AcademyInfo _selectedAcademy) {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => AcademyInfoPage(_selectedAcademy)
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _getSearchResult();
    _getMoreSearchResult();
  }

  /* TODO: 검색 결과 없을 시 없다고 화면에 표시 */

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
                                      '필터 :   ' + widget._selectedSido + ' ' + widget._selectedGungu + ' '
                                          + widget._selectedDong + '   /   ' + widget._selectedSubject + '   /   '
                                          + widget._selectedAge + '등',
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
                          children: List.generate(_searchResult.length, (index) {
                            return SizedBox(
                                width: screenWidth * 0.9,
                                height: screenWidth * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RawMaterialButton(
                                      onPressed: () => _academyClicked(_searchResult[index]),
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
                                                          _searchResult[index].name,
                                                          style: TextStyle(
                                                            fontFamily: 'dream5',
                                                            fontSize: screenWidth * 0.055,
                                                            letterSpacing: -2,
                                                            color: Colors.black,
                                                          )
                                                      ),

                                                      // 학원 주소
                                                      Text(
                                                          _searchResult[index].addr,
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

                          // additional result
                            + [
                              _moreResultLeft
                                ? SizedBox(
                                  width: screenWidth * 0.9,
                                  height: screenWidth * 0.15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          if (_searchResultBuffer.length != 0) {
                                            setState(() {
                                              _searchResult.addAll(_searchResultBuffer);
                                            });
                                            _getMoreSearchResult();
                                          }
                                        },
                                        child: Container(
                                            width: screenWidth * 0.9,
                                            child: Center(
                                                child: Text(
                                                    '검색 결과 더 보기',
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
                                : SizedBox()
                              ]
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