import 'dart:async';
import 'dart:io';
import 'package:dbsqflite2/models/todo_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final dbName = "myDB.db";
  static final dbVersion = 1;
  static final tableName = "DBtable";
  static final colId = "id";
  static final colTitle = "title";
  static final colDesc = "desc";
  static final colTime = "time";

  DatabaseHelper._createInstance();
  static final DatabaseHelper instacne = DatabaseHelper._createInstance();

  static Database _database;
  Future<Database> get get_database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $tableName (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colTitle TEXT,
      $colDesc TEXT,
      $colTime TEXT)
    ''');
  }

  insert(ToDoList toDoList) async {
    print(toDoList.title + "  " + toDoList.desc + "    " + toDoList.time);
    Database db = await instacne.get_database;
    var result = await db.insert(tableName, toDoList.toMap());
    print("Insert Result : $result");
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instacne.get_database;
    return await db.query(tableName);
  } //return List Map <String , {dynamic> "id":1, "name": "Name"}

  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await instacne.get_database;
  //   int id = row[colId];
  //   return await db
  //       .update(tableName, row, where: '$colId = ?', whereArgs: [id]);
  // }

  delete(int id) async {
    Database db = await instacne.get_database;
    return await db.delete(tableName, where: '$colId = ?', whereArgs: [id]);
  }

  getCount() async {
    Database db = await instacne.get_database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    print("x : $x");
    int result = Sqflite.firstIntValue(x);
    print("result get count : $result");
    return result;
  }

  Future<List<ToDoList>> getAlarms() async {
    List<ToDoList> _alarms = [];

    var db = await instacne.get_database;
    var result = await db.query(tableName);
    result.forEach((element) {
      var alarmInfo = ToDoList.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }
}
