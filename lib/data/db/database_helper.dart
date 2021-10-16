import 'package:laporhoax/data/model/feed.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblNews = 'news';

  Future<Database> _initialDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/laporhoax.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblNews (
        id INTEGER PRIMARY KEY,
        title TEXT,
        thumbnail TEXT,
        date TEXT
        )
        ''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initialDb();
    }
    return _database;
  }

  Future<void> insertNews(Feed feed) async {
    final db = await database;
    await db!.insert(_tblNews, feed.toJson());
  }

  Future<List<Feed>> getFeeds() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblNews);

    return results.map((res) => Feed.fromJson(res)).toList();
  }

  Future<Map> getFeedById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblNews,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeNews(String id) async {
    final db = await database;

    await db!.delete(
      _tblNews,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
