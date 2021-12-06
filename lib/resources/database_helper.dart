import 'dart:io' show Directory;
import 'package:app/models/inventory_model.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

class DatabaseHelper {
  static final _databaseName = "Inventory.db";
  static final _databaseVersion = 1;

  static final table = 'my_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAmount = 'amount';
  static final columnMeasurement = 'measurement';

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
      'CREATE TABLE $table ($columnId INTEGER PRIMARY KEY, $columnName TEXT NOT NULL, $columnAmount INTEGER NOT NULL, $columnMeasurement TEXT NOT NULL)'
    );
  }

  Future<List<Map<String, dynamic>>> getList() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery('SELECT * FROM $table');
    return result;
  }
}