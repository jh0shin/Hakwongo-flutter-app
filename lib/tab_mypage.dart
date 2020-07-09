import 'package:flutter/material.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {

  // Back Button Event controller
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("학원GO를 종료하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text("네"),
              onPressed: () => Navigator.pop(context, true),
            ),
            FlatButton(
              child: Text("아니오"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Center(
        child: Text(
            "탭 - 마이페이지",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}