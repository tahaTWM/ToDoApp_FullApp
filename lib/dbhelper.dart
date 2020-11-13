import 'dart:async';
import 'dart:io';
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

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instacne = DatabaseHelper._privateConstructor();

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

  Future onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $tableName (
      $colId INTEGER PRIMARY KEY,
      $colTitle TEXT,
      $colDesc TEXT,
      $colTime TEXT)
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instacne.get_database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instacne.get_database;
    return await db.query(tableName);
  } //return List Map <String , {dynamic> "id":1, "name": "Name"}

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instacne.get_database;
    int id = row[colId];
    return await db
        .update(tableName, row, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instacne.get_database;
    return await db.delete(tableName, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> getCount() async {
    Database db = await instacne.get_database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
