import 'dart:convert';
import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import '../features/products/model/product.dart';

/// Only public catalog data, favourite products and preferences go in SQLite.
/// Authentication tokens are owned exclusively by ApiService's secure storage.
class LocalStore {
  Future<Database>? _database;
  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async {
    try {
      return await openDatabase(
        '${await getDatabasesPath()}/catalog.db',
        version: 1,
        onCreate: (db, _) async {
          await db.execute(
            'CREATE TABLE preferences (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE favourites (id INTEGER PRIMARY KEY, product TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE images (url TEXT PRIMARY KEY, bytes BLOB NOT NULL)',
          );
        },
      );
    } catch (_) {
      _database = null;
      rethrow;
    }
  }

  Future<String?> read(String key) async {
    final rows = await (await database).query(
      'preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
    return rows.isEmpty ? null : rows.first['value'] as String;
  }

  Future<void> write(String key, String value) async {
    await (await database).insert('preferences', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> readFavourites() async {
    final rows = await (await database).query('favourites', orderBy: 'id');
    return rows
        .map(
          (row) => Product.fromJson(
            jsonDecode(row['product'] as String) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> setFavourite(Product product, bool saved) async {
    final db = await database;
    if (saved) {
      await db.insert('favourites', {
        'id': product.id,
        'product': jsonEncode(product.toJson()),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.delete('favourites', where: 'id = ?', whereArgs: [product.id]);
    }
  }

  Future<Uint8List?> readImage(String url) async {
    final rows = await (await database).query(
      'images',
      where: 'url = ?',
      whereArgs: [url],
    );
    return rows.isEmpty ? null : rows.first['bytes'] as Uint8List;
  }

  Future<void> saveImage(String url, Uint8List bytes) async {
    await (await database).insert('images', {
      'url': url,
      'bytes': bytes,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
