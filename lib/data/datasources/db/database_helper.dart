import 'package:laporhoax/data/models/feed_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblFeeds = 'feeds';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/laporhoax.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tblFeeds (
      id INTEGER PRIMARY KEY,
      title TEXT,
      thumbnail TEXT,
      date TEXT
    );
    ''');
  }

  Future<void> insertNews(FeedTable feed) async {
    final db = await database;
    await db!.insert(_tblFeeds, feed.toJson());
  }

  Future<List<Map<String, dynamic>>> getFeeds() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFeeds);

    return results;
  }

  Future<Map<String, dynamic>?> getFeedById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblFeeds,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<void> removeFeed(FeedTable feed) async {
    final db = await database;

    await db!.delete(
      _tblFeeds,
      where: 'id = ?',
      whereArgs: [feed.id],
    );
  }
}
