import 'package:backend/M03/ShoppingList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _database;
  final String _table_name = "shopping_list";
  final String _db_name = "shopinglist_database";
  final int _db_version = 1;

  DBHelper() {
    _openDB();
  }

  Future<void> _openDB() async {
    // penghapusan database digunakan, ketika anda sudah membuat database,
    // dan ternyata terjadi perubah pada table
    // await deleteDatabase(
    //     join(await getDatabasePath(), 'shopinglist_database.db'));
    _database ??= await openDatabase(
      join(await getDatabasesPath(), _db_name),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_table_name (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)',
        );
      },
      version: _db_version,
    );
  }

  Future<void> insertShoppingList(ShoppingList tmp) async {
    await _database?.insert(
      'shopping_list',
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ShoppingList>> getmyShopingList() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps =
          await _database!.query('shopping_list');
      print("Isi DB" + maps.toString());
      return List.generate(maps.length, (i) {
        return ShoppingList(maps[i]['id'], maps[i]['name'], maps[i]['sum']);
      });
    }
    return [];
  }

  Future<void> deleteShoppingList(int id) async {
    await _database?.delete(
      'shopping_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDB() async {
    await _database?.close();
  }
}
