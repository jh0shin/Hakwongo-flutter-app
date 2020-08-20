import 'package:flutter/material.dart';

import 'package:hwgo/tab/tab_recent.dart';
import 'package:hwgo/tab/tab_main.dart';
import 'package:hwgo/tab/tab_mypage.dart';
import 'package:hwgo/tab/tab_service.dart';

import 'package:hwgo/settings.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  int _selectedIndex = 0;

  List _pages = [
    TabMainPage(),
    RecentPage(),
    MyInfoPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Center(child: _pages[_selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: screenWidth * 0.05
            ),
            title: Text(
              '메인',
              style: TextStyle(
                fontFamily: 'dream5',
                fontSize: screenWidth * 0.035,
                letterSpacing: -1,
                color: Colors.black,
              )
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.access_time,
              size: screenWidth * 0.05
            ),
            title: Text(
              '최근검색',
              style: TextStyle(
                fontFamily: 'dream5',
                fontSize: screenWidth * 0.035,
                letterSpacing: -1,
                color: Colors.black,
              )
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: screenWidth * 0.05),
            title: Text(
              '마이페이지',
              style: TextStyle(
                fontFamily: 'dream5',
                fontSize: screenWidth * 0.035,
                letterSpacing: -1,
                color: Colors.black,
              )
            )
          ),
        ]
      ),
    );
  }
}