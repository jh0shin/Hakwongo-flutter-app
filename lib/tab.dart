import 'package:flutter/material.dart';

import 'package:hwgo/tab_main.dart';
import 'package:hwgo/tab_mypage.dart';
import 'package:hwgo/tab_recent.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  // background color
  Color _bgcolor = const Color(0xFF504f4b);
  Color _highlight = const Color(0xFFfff2cc);
  Color _btncolor = const Color(0xFF353430);

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
      backgroundColor: _bgcolor,
      body: SafeArea(
        child: Center(child: _pages[_selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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
            icon: Icon(Icons.access_time),
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
            icon: Icon(Icons.account_circle),
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