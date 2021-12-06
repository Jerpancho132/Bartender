import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

class DatabaseHelper {
  static final _databaseName = "Favorite.db";
  static final _databaseVersion = 1;

  static final table = 'cocktails';

  static final columnId = '_id';
  static final columnId2 = 'id';

  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Database? _database;
  Future<Database> get database async => 
    _database ??= await _initDatabase();

  _initDatabase() async {
    Directory documnetsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documnetsDirectory.path, _databaseName);
    return await openDatabase(path,
    version: _databaseVersion,
    onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $table ($columnId INTEGER PRIMARY KEY, $columnId2 INTEGER NOT NULL)'
    );
  }

  Future<List<Map<String, dynamic>>> getList() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery('SELECT * FROM $table');
    return result;
  }
}