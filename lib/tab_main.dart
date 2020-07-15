import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hwgo/settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/userbloc.dart';

import 'package:hwgo/search.dart';

class TabMainPage extends StatefulWidget {
  @override
  _TabMainPageState createState() => _TabMainPageState();
}

class _TabMainPageState extends State<TabMainPage> {

  // selected location
  String _selectedSido = '';
  String _selectedGungu = '';
  String _selectedDong = '';
  String _selectedSubject = '';
  String _selectedAge = '';

  // banner image local path
  List<String> _banner = [
    'assets/image/ad_1.png',
    'assets/image/ad_2.png',
    'assets/image/ad_3.png',
    'assets/image/ad_4.png',
  ];
  // banner slider index
  int _currentBanner = 0;

  Map<String, String> _sido = {'서울':'서울특별시', '경기':'경기도', '부산':'부산광역시',
    '대구':'대구광역시', '인천':'인천광역시', '광주':'광주광역시', '대전':'대전광역시',
    '울산':'울산광역시', '세종':'세종특별자치시', '강원':'강원도', '충북':'충청북도', '충남':'충청남도',
    '전북':'전라북도', '전남':'전라남도', '경북':'경상북도', '경남':'경상남도', '제주':'제주도'};

  Map<String, List<String>> _gungu = {
    '경기도': ['', '성남시 분당구', '용인시 기흥구', '용인시 수지구',
      '수원시 장안구', '수원시 권선구', '수원시 팔달구', '수원시 영통구', '고양시 덕양구',
      '고양시 일산동구', '고양시 일산서구', '성남시 수정구', '성남시 중원구',
      '용인시 처인구',  '부천시', '안산시 상록구' ,'안산시 단원구',
      '남양주시', '안양시 만안구', '안산시 동안구', '화성시', '평택시', '의정부시', '시흥시',
      '파주시','김포시', '광명시', '광주시', '군포시', '오산시', '이천시', '양주시', '안성시',
      '구리시', '포천시', '의왕시', '하남시', '여주시', '양평군', '동두천시', '과천시', '가평군',
      '연천군']
  };

//  Map<String, List<String>> _gungu = {
//    '서울특별시': ['', '종로구', '중구', '용산구', '성동구', '광진구','동대문구', '중랑구', '성북구', '강북구',
//      '도봉구', '노원구', '은평구', '서대문구', '마포구', '양천구', '강서구', '구로구', '금천구',
//      '영등포구', '동작구', '관악구', '서초구', '강남구', '송파구', '강동구'],
//    '부산광역시': ['', '중구', '서구', '동구', '영도구', '부산진구', '동래구', '남구', '북구', '해운대구',
//      '사하구', '금정구', '강서구', '연제구', '수영구', '사상구', '기장군'],
//    '대구광역시': ['', '중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '달성군'],
//    '인천광역시': ['', '중구', '동구', '미추홀구', '연수구', '남동구', '부평구', '계양구', '서구', '강화군',
//      '옹진군'],
//    '광주광역시': ['', '동구', '중구', '서구', '북구', '광산구'],
//    '대전광역시': ['', '동구', '중구', '서구', '유성구', '대덕구'],
//    '울산광역시': ['', '중구', '남구', '동구', '북구', '울주군'],
//    '세종특별자치시': ['', '세종특별자치시'],
//    '경기도': ['', '성남시 분당구', '용인시 기흥구', '용인시 수지구',
//      '수원시 장안구', '수원시 권선구', '수원시 팔달구', '수원시 영통구', '고양시 덕양구',
//      '고양시 일산동구', '고양시 일산서구', '성남시 수정구', '성남시 중원구',
//      '용인시 처인구',  '부천시', '안산시 상록구' ,'안산시 단원구',
//      '남양주시', '안양시 만안구', '안산시 동안구', '화성시', '평택시', '의정부시', '시흥시',
//      '파주시','김포시', '광명시', '광주시', '군포시', '오산시', '이천시', '양주시', '안성시',
//      '구리시', '포천시', '의왕시', '하남시', '여주시', '양평군', '동두천시', '과천시', '가평군',
//      '연천군'],
//    '강원도': ['', '춘천시', '원주시', '강릉시', '동해시', '태백시', '속초시', '삼척시', '홍천군',
//      '횡성군', '영월군', '평창군', '정선군', '철원군', '화천군', '양구군', '인제군', '고성군',
//      '양양군'],
//    '충청북도': ['', '청주시 상당구', '청주시 서원구', '청주시 흥덕구', '청주시 청원구', '충주시',
//      '제천시', '보은군', '옥천군', '영동군', '증평군', '진천군', '괴산군', '음성군', '단양군'],
//    '충청남도': ['', '천안시 동남구', '천안시 서북구', '공주시', '보령시', '아산시', '서산시', '논산시',
//      '계룡시', '당진시', '금산군', '부여군', '서천군', '청양군', '홍성군', '예산군', '태안군'],
//    '전라북도': ['', '전주시 완산구', '전주시 덕진구', '군산시', '익산시', '정읍시', '남원시', '김제시',
//      '완주군', '진안군', '무주군', '장수군', '임실군', '순창군', '고창군', '부안군'],
//    '전라남도': ['', '목포시', '여수시', '순천시', '나주시', '광양시', '담양군', '곡성군', '구례군',
//      '고흥군', '보성군', '화순군', '장흥군', '강진군', '해남군', '영암군', '무안군', '함평군',
//      '영광군', '장성군', '완도군', '진도군', '신안군'],
//    '경상북도': ['', '포항시 남구', '포항시 북구', '경주시', '김천시', '안동시', '구미시', '영주시',
//      '영천시', '상주시', '문경시', '경산시', '군위군', '의성군', '청송군', '영양군', '영덕군',
//      '청도군', '고령군', '성주군', '칠곡군', '예천군', '봉화군', '울진군', '울릉군'],
//    '경상남도': ['', '창원시 의창구', '창원시 성산구', '창원시 마산합포구', '창원시 마산회원구',
//      '창원시 진해구', '진주시', '통영시', '사천시', '김해시', '밀양시', '거제시', '양산시',
//      '의령군', '함안군', '창녕군', '고성군', '남해군', '하동군', '산청군', '함양군', '거창군',
//      '합천군'],
//    '제주도': ['', '제주시', '서귀포시']
//  };

  Map<String, List<String>> _dong = {
    '성남시 분당구' : ['', '분당동', '수내동', '정자동', '서현동', '이매동', '야탑동',
    '금곡동', '구미동', '판교동', '삼평동', '백현동', '운중동'],
    '용인시 기흥구' : ['', '구갈동', '신갈동', '상갈동', '보라동', '영덕1동', '영덕2동', '서농동',
    '기흥동', '구성동', '마북동', '보정동', '동백1동', '동백2동', '동백3동', '상하동'],
    '용인시 수지구' : ['', '풍덕천1동', '풍덕천2동', '상현1동', '상현2동', '성복동', '신봉동',
    '동천동', '죽전1동', '죽전2동']
  };

  void _locationPageDispose(BuildContext context) {
    Navigator.pop(context);
    setState(() {});
  }

  // location select button clicked
  void _locationButtonClicked() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          // ignore: missing_return
          onWillPop: (){},
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                double screenWidth = MediaQuery.of(context).size.width;

                return Material(
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
                                      child: Text("지역선택",
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
                                      onPressed: () => _locationPageDispose(context),
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

                        // index
                        Row(
                          children: <Widget>[
                            SizedBox(
                                width: screenWidth * 0.25,
                                height: screenWidth * 0.15,
                                child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Text(
                                        "시/도",
                                        style: TextStyle(
                                          fontFamily: 'dream6',
                                          fontSize: screenWidth * 0.045,
                                          letterSpacing: -2,
                                          color: Colors.black,
                                        )
                                    )
                                )
                            ),

                            SizedBox(
                                width: screenWidth * 0.45,
                                height: screenWidth * 0.15,
                                child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Text(
                                        "시/구/군",
                                        style: TextStyle(
                                          fontFamily: 'dream6',
                                          fontSize: screenWidth * 0.045,
                                          letterSpacing: -2,
                                          color: Colors.black,
                                        )
                                    )
                                )
                            ),

                            SizedBox(
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.15,
                                child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Text(
                                        "동/읍/면",
                                        style: TextStyle(
                                          fontFamily: 'dream6',
                                          fontSize: screenWidth * 0.045,
                                          letterSpacing: -2,
                                          color: Colors.black,
                                        )
                                    )
                                )
                            ),
                          ],
                        ),

                        // Contour line
                        Container(
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.black12),
                          ),
                        ),

                        // listview (scrollable)
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: <Widget>[

                              // sido
                              Container(
                                width: screenWidth * 0.25,
                                child: ListView.builder(
                                    itemCount: _sido.length,
                                    itemBuilder: (context, i) {
                                      if (_gungu.containsKey(_sido[_sido.keys.toList()[i]])) {
                                        return RawMaterialButton(
                                          onPressed: (){
                                            setState(() {
                                              _selectedSido = _sido[_sido.keys.toList()[i]];
                                              _selectedGungu = '';
                                              _selectedDong = '';
                                            });
                                          },
                                          child: Container(
                                            width: screenWidth * 0.25,
                                            height: screenWidth * 0.15,
                                            color: _sido[_sido.keys.toList()[i]] == _selectedSido
                                                ? highlightcolor
                                                : Colors.white,
                                            child: Center(
                                                child: Text(
                                                    _sido.keys.toList()[i],
                                                    style: TextStyle(
                                                      fontFamily: 'dream5',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          width: screenWidth * 0.25,
                                          height: screenWidth * 0.15,
                                          color: _sido[_sido.keys.toList()[i]] == _selectedSido
                                              ? highlightcolor
                                              : Colors.white,
                                          child: Center(
                                              child: Text(
                                                  _sido.keys.toList()[i],
                                                  style: TextStyle(
                                                    fontFamily: 'dream5',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.grey,
                                                  )
                                              )
                                          ),
                                        );
                                      }

                                    }
                                ),
                              ),

                              // Contour line
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.black12),
                                ),
                              ),

                              // gungu
                              Container(
                                width: screenWidth * 0.45 - 2,
                                child: _selectedSido == ''
                                    ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                        "시/도를\n선택해주세요",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'dream3',
                                          fontSize: screenWidth * 0.04,
                                          letterSpacing: -1,
                                          color: Colors.black12,
                                        )
                                    )
                                )
                                    : ListView.builder(
                                    itemCount: _gungu[_selectedSido].length,
                                    itemBuilder: (context, i) {
                                      if (_dong.containsKey(_gungu[_selectedSido][i])) {
                                        return RawMaterialButton(
                                          onPressed: (){
                                            setState(() {
                                              _selectedGungu = _gungu[_selectedSido][i];
                                              _selectedDong = '';
                                            });
                                          },
                                          child: Container(
                                            width: screenWidth * 0.45,
                                            height: screenWidth * 0.15,
                                            color: _gungu[_selectedSido][i] == _selectedGungu
                                                ? highlightcolor
                                                : Colors.white,
                                            child: Center(
                                                child: Text(
                                                    _gungu[_selectedSido][i] == '' ? '전 지역' : _gungu[_selectedSido][i],
                                                    style: TextStyle(
                                                      fontFamily: 'dream5',
                                                      fontSize: screenWidth * 0.04,
                                                      letterSpacing: -1,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          width: screenWidth * 0.45,
                                          height: screenWidth * 0.15,
                                          color: _gungu[_selectedSido][i] == _selectedGungu
                                              ? highlightcolor
                                              : Colors.white,
                                          child: Center(
                                              child: Text(
                                                  _gungu[_selectedSido][i] == '' ? '전 지역' : _gungu[_selectedSido][i],
                                                  style: TextStyle(
                                                    fontFamily: 'dream5',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                    color: Colors.grey,
                                                  )
                                              )
                                          ),
                                        );
                                      }

                                    }
                                ),
                              ),

                              // Contour line
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.black12),
                                ),
                              ),

                              // dong
                              Container(
                                width: screenWidth * 0.3,
                                child: _selectedGungu == ''
                                    ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                        "시/구/군을\n선택해주세요",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'dream3',
                                          fontSize: screenWidth * 0.04,
                                          letterSpacing: -1,
                                          color: Colors.black12,
                                        )
                                    )
                                )
                                    : ListView.builder(
                                    itemCount: _dong[_selectedGungu].length,
                                    itemBuilder: (context, i) {
                                      return RawMaterialButton(
                                        onPressed: (){
                                          setState(() {
                                            _selectedDong = _dong[_selectedGungu][i];
                                          });
                                        },
                                        child: Container(
                                          width: screenWidth * 0.3,
                                          height: screenWidth * 0.15,
                                          color: _dong[_selectedGungu][i] == _selectedDong
                                              ? highlightcolor
                                              : Colors.white,
                                          child: Center(
                                              child: Text(
                                                  _dong[_selectedGungu][i] == '' ? '전 지역' : _dong[_selectedGungu][i],
                                                  style: TextStyle(
                                                    fontFamily: 'dream5',
                                                    fontSize: screenWidth * 0.04,
                                                    letterSpacing: -1,
                                                  )
                                              )
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),

                            ],
                          ),
                        ),

                        // selected location
                        SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              color: highlightcolor,
                              child: Text(
                                  '       X  ' + _selectedSido + ' ' + _selectedGungu + ' ' + _selectedDong,
                                  style: TextStyle(
                                      fontFamily: 'dream5',
                                      fontSize: screenWidth * 0.03,
                                      letterSpacing: -1,
                                      color: Colors.black
                                  )
                              ),
                            )
                        ),

                        // select button
                        SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.15,
                            child: RawMaterialButton(
                                onPressed: () => _locationPageDispose(context),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Text(
                                      '확인',
                                      style: TextStyle(
                                          fontFamily: 'dream5',
                                          fontSize: screenWidth * 0.07,
                                          letterSpacing: -2,
                                          color: Colors.black
                                      )
                                  ),
                                )
                            )
                        ),

                      ],
                    )
                );
              }
          ),
        );
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

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      // screen width
      double screenWidth = MediaQuery.of(context).size.width;

      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          decoration: BoxDecoration(color: bgcolor),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Scrollable screen
                  Flexible(
                      flex: 1,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[

                          // Space ===============
                          SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.05,
                            child: Container(color: bgcolor),
                          ),
                          // Space ===============

                          // logo
                          // image size : 1924 * 1462 px
                          Image.asset(
                            'assets/image/logo.png',
                            width: screenWidth * 0.4,
                            height: screenWidth * 0.4 * (1462 / 1924),
                          ),

                          // carousel ad card
                          SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.4,
                            child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Stack(
                                  children: <Widget>[
                                    CarouselSlider(
                                      height: screenWidth * 0.4,
                                      autoPlay: true,
                                      viewportFraction: 1.0,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentBanner = index;
                                        });
                                      },
                                      items: _banner.map(
                                              (i) {
                                            return Container(
                                              color: bgcolor,
                                              padding: EdgeInsets.all(10),
                                              child: Image.asset(i),
                                            );
                                          }
                                      ).toList(),
                                    ),

                                    // indicate dot
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(_banner.length, (index) {
                                          return Container(
                                            width: screenWidth * 0.01,
                                            height: screenWidth * 0.01,
                                            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.01, horizontal: screenWidth * 0.01),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _currentBanner == index
                                                  ? Color.fromRGBO(255, 255, 255, 0.9)
                                                  : Color.fromRGBO(255, 255, 255, 0.4),
                                            ),
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ),

                          // location select
                          RawMaterialButton(
                            onPressed: _locationButtonClicked,
                            child: SizedBox(
                              width: screenWidth,
                              height: screenWidth * 0.15,
                              child: Container(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: bgcolor),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.white,
                                    ),
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

                                        Text(
                                          _selectedSido == ''
                                              ? '지역 선택'
                                              : _selectedSido + ' ' + _selectedGungu + ' ' + _selectedDong,
                                          style: TextStyle(
                                            fontFamily: 'dream5',
                                            fontSize: screenWidth * 0.038,
                                            letterSpacing: -2,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ),


                          // subject select
                          SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.5,
                            child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: bgcolor),
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // korean
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '국어' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '국어';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_kor.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '국어',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Contour Line
                                          Container(
                                            height: screenWidth * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // english
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '영어' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '영어';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_eng.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '영어',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Conture Line
                                          Container(
                                            height: screenWidth * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // math
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '수학' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '수학';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_math.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '수학',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Conture Line
                                          Container(
                                            height: screenWidth * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // social
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '사회' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '사회';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_social.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '사회',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Conture Line
                                      Container(
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.5, color: Colors.black12),
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[

                                          // science
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '과학' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '과학';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_sci.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '과학',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Conture Line
                                          Container(
                                            height: screenWidth * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // writing
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '논술' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '논술';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_write.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '논술',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Conture Line
                                          Container(
                                            height: screenWidth * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // entertainment
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '예체능' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '예체능';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_kor.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '예체능',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Conture Line
                                          Container(
                                            height: screenWidth * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // etc
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedSubject == '기타' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedSubject = '기타';
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/sub_kor.png',
                                                    width: screenWidth * 0.15,
                                                    height: screenWidth * 0.15,
                                                  ),
                                                  Text(
                                                      '기타',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),

                          // age, search button
                          Row(
                            children: <Widget>[
                              // age select button
                              SizedBox(
                                width: screenWidth * 0.7,
                                height: screenWidth * 0.2,
                                child: Container(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: bgcolor),
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // 초등
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedAge == '초' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedAge = '초';
                                                });
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: screenWidth * 0.14,
                                                  child: Text(
                                                      '초등',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                              ),
                                            ),
                                          ),

                                          // Conture Line
                                          Container(
                                            height: screenWidth * 0.1,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // 중등
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedAge == '중' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedAge = '중';
                                                });
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: screenWidth * 0.14,
                                                  child: Text(
                                                      '중등',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                              ),
                                            ),
                                          ),

                                          // Contour Line
                                          Container(
                                            height: screenWidth * 0.1,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 0.5, color: Colors.black12),
                                            ),
                                          ),

                                          // 고등
                                          Flexible(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: _selectedAge == '고' ? highlightcolor : Colors.white,
                                              elevation: 0,
                                              onPressed: (){
                                                setState(() {
                                                  _selectedAge = '고';
                                                });
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: screenWidth * 0.14,
                                                  child: Text(
                                                      '고등',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'dream5',
                                                        fontSize: screenWidth * 0.05,
                                                        letterSpacing: -2,
                                                        color: Colors.black,
                                                      )
                                                  )
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    )
                                ),
                              ),

                              // search button
                              SizedBox(
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.2,
                                child: Container(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  child: RawMaterialButton(
                                      onPressed: (){
                                        Navigator.push(
                                          context, MaterialPageRoute(
                                            builder: (context) => SearchPage(
                                                _selectedSido, _selectedGungu, _selectedDong, _selectedSubject, _selectedAge)
                                          ),
                                        );
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: bgcolor),
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: btncolor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "검색",
                                              style: TextStyle(
                                                fontFamily: 'dream5',
                                                fontSize: screenWidth * 0.05,
                                                letterSpacing: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Space ===============
                          SizedBox(
                            width: screenWidth,
                            height: screenWidth * 0.05,
                            child: Container(color: bgcolor),
                          ),
                          // Space ===============

                        ],
                      )
                  ),

                ],
              )
          ),
        ),
      );
    }
  );
}