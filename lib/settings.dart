import 'package:flutter/material.dart';

// background color
Color bgcolor = const Color(0xFF504f4b);
Color highlightcolor = const Color(0xFFfff2cc);
Color btncolor = const Color(0xFF353430);
Color commentcolor = const Color(0xFFFFF2CD);

// AcademyInfo class for encoded json data from http request
class AcademyInfo {
  final int id;           // 학원 고유 id
  final String name;      // 학원 이름
  final String addr;      // 학원 주소
  final String founder;   // 학원 설립자
  final String callnum;   // 학원 전화번호

  // constructor
  AcademyInfo({
    this.id,
    this.name,
    this.addr,
    this.founder,
    this.callnum,
  });

  // factory constructor
  factory AcademyInfo.fromJSON(Map<String, dynamic> json) {
    return AcademyInfo(
      id : json['id'],
      name : json['name'],
      addr : json['addr'],
      founder : json['founder'],
      callnum : json['callnum'],
    );
  }
}

// AcademyClass class for encoded json data from http request
class AcademyClass {
  final int id;        // 학원 고유 id
  final String classname;
  final String age;
  final String size;
  final String time;
  final String totaltime;
  final String cost1;
  final String cost2;
  final String cost3;
  final String cost4;
  final String cost5;
  final String cost6;
  final String cost7;
  final String teacher;

  // constructor
  AcademyClass({
    this.id,
    this.classname,
    this.age,
    this.size,
    this.time,
    this.totaltime,
    this.cost1,
    this.cost2,
    this.cost3,
    this.cost4,
    this.cost5,
    this.cost6,
    this.cost7,
    this.teacher,
  });

  // factory constructor
  factory AcademyClass.fromJSON(Map<String, dynamic> json) {
    return AcademyClass(
      id : json['id'],
      classname : json['class'],
      age : json['age'],
      size : json['size'],
      time : json['time'],
      totaltime : json['totaltime'],
      cost1 : json['cost1'],
      cost2 : json['cost2'],
      cost3 : json['cost3'],
      cost4 : json['cost4'],
      cost5 : json['cost5'],
      cost6 : json['cost6'],
      cost7 : json['cost7'],
      teacher : json['teacher'],
    );
  }
}

// AcademyComment class for encoded json data from http request
class AcademyComment {
  final int id;
  final String user;
  final String comment;
  final String time;
  final int heart;

  // constructor
  AcademyComment({
    this.id,
    this.user,
    this.comment,
    this.time,
    this.heart,
  });

  // factory constructor
  factory AcademyComment.fromJSON(Map<String, dynamic> json) {
    return AcademyComment(
      id: json['id'],
      user: json['user'],
      comment: json['comment'],
      time: json['time'],
      heart: json['heart'],
    );
  }
}

class BookmarkedAcademy {
  final String user;
  final int id;
  // constructor
  BookmarkedAcademy({
    this.user,
    this.id
  });

  // factory constructor
  factory BookmarkedAcademy.fromJSON(Map<String, dynamic> json) {
    return BookmarkedAcademy(
      user: json['user'],
      id: json['id'],
    );
  }
}