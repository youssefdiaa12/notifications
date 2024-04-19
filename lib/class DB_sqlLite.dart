import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlLite {
  static Database? db;

  Future<String> getDbLocation() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'example.db');
    return path;
  }

  Future<Database> openDatabase1() async {
    var path = await getDbLocation();
    var db = await openDatabase(path);
    return db;
  }

  Future<void> createDatabase(String name) async {
    db = await openDatabase1();
    await db!.execute(
        'CREATE TABLE $name (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  }

  Future<void> insertToDatabase(String tableName) async {
    await db!.rawInsert(
        "INSERT INTO $tableName (name, value, num) VALUES (?, ?, ?)",
        ['dada', 1234, 3.4]);
  }

  Future<void> updateToDatabase(String tableName) async {
    await db!.rawUpdate(
        "UPDATE $tableName SET name = ? WHERE name = ?", ['dido', 'lola']);
  }

  Future<void> deleteFromDatabase(String tableName, int id) async {
    await db!.rawDelete("DELETE FROM $tableName WHERE id = ?", [id]);
  }
}
