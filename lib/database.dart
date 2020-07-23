import 'dart:io';
import 'package:hwgo/settings.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;
  
  // call db, create if no db exists
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }
  
  // initial database table create
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'recent.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          create table hakwon (
            id int not null primary key,
            name varchar(80),
            addr varchar(200),
            founder varchar(40),
            callnum varchar(20)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {}
    );
  }
  
  // CRUD ==============================
  // Create
  createData(AcademyInfo academy) async {
    final db = await database;
    var res = await db.rawInsert('''
      insert into hakwon (id, name, addr, founder, callnum)
      values (?, ?, ?, ?, ?)
      ''',
      [academy.id, academy.name, academy.addr, academy.founder, academy.callnum]
    );
    return res;
  }

  // Read all
  Future<List<AcademyInfo>> getAllData(int offset, int limit) async {
    final db = await database;
    var res = await db.rawQuery('select distinct id, name, addr, founder, callnum from hakwon limit ?, ?',
    [offset, limit]);
    List<AcademyInfo> list = res.isNotEmpty
      ? res.map((item) => AcademyInfo.fromJSON(item)).toList()
      : [];

    return list;
  }

  // Delete all
  deleteAll() async {
    final db = await database;
    db.rawDelete('Delete from hakwon');
  }
}