import 'package:flutter/material.dart';

import 'package:hwgo/tab_main.dart';
import 'package:hwgo/tab_mypage.dart';
import 'package:hwgo/tab_recent.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Center(child: _pages[_selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), title: Text('메인')),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time), title: Text('최근검색')),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), title: Text('사용자')),
        ]
      ),
    );
  }
}