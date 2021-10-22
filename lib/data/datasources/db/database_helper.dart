import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
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
  static const String _tblSession = 'session';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/laporhoax.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_tblFeeds (
      id INTEGER PRIMARY KEY,
      title TEXT,
      thumbnail TEXT,
      date TEXT
    );''');

    await db.execute('''
    CREATE TABLE $_tblSession (
      token TEXT,
      expire TEXT,
      userId TEXT,
      username TEXT,
      email TEXT
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

  Future<void> insertSession(SessionData data) async {
    final db = await database;
    await db!.insert(_tblSession, data.toJson());
  }

  Future<Map<String, dynamic>?> getLastSessions() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblSession, limit: 1);
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<void> updateSession(SessionData data) async {
    final db = await database;
    await db!.update(
      _tblSession,
      data.toJson(),
      where: 'token = ?',
      whereArgs: [data.token],
    );
  }

  Future<void> removeSession(SessionData data) async {
    final db = await database;

    await db!.delete(
      _tblSession,
      where: 'token = ?',
      whereArgs: [data.token],
    );
  }
}
