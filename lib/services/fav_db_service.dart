import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant_detail.dart';

class FavDbService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'fav.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) {
        return db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            name TEXT,
            city TEXT,
            address TEXT,
            pictureId TEXT,
            rating REAL,
            description TEXT,
            categories TEXT,
            foods TEXT,
            drinks TEXT,
            customerReviews TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  Future<void> addFavorite(RestaurantDetail r) async {
    final database = await db;
    await database.insert(
      'favorites',
      r.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final database = await db;
    await database.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final database = await db;
    final res = await database.query('favorites', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty;
  }

  Future<List<RestaurantDetail>> getFavorites() async {
    final database = await db;
    final rows = await database.query('favorites');
    return rows.map((r) => RestaurantDetail.fromMap(r)).toList();
  }
}
