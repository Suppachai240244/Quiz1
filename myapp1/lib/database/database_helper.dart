import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'userlist.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const _databaseName = 'UserDb.db';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDir = await getApplicationDocumentsDirectory();

    String dbPath = join(dataDir.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateTable);
  }

  _onCreateTable(Database db, int version) async {
    await db.execute('''
CREATE TABLE ${User.tableName}(
${User.colName} TEXT PRIMARY KEY,
${User.colage} INTEGER NOT NULL,
${User.colemail} TEXT NOT NULL,
${User.colprovince} TEXT NOT NULL,
${User.colidcard} INTEGER NOT NULL
)''');
  }

//insert
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert(
      User.tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//delete
  Future<int> deleteUser(String name) async {
    Database db = await database;
    return await db
        .delete(User.tableName, where: '${User.colName}=?', whereArgs: [name]);
  }

//pull
  Future<List<User>> fetchUsers() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(User.tableName);
    if (maps.isEmpty) {
      return [];
    } else {
      return List.generate(maps.length, (index) {
        return User(
            name: maps[index][User.colName],
            age: maps[index][User.colage],
            email: maps[index][User.colemail],
            province: maps[index][User.colprovince],
            idcard: maps[index][User.colidcard]);
      });
    }
  }
}
