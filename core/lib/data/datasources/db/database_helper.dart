import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/question.dart';
import '../../models/feed_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblFeeds = 'feeds';
  static const String _tblCategories = 'categories';
  static const String _tblQuestions = 'questions';

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

    await db.execute('''CREATE TABLE $_tblQuestions (
      id INTEGER PRIMARY KEY,
      question TEXT
    );''');

    await db.execute('''CREATE TABLE $_tblCategories (
      id INTEGER PRIMARY KEY,
      name TEXT
    );''');
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

  Future<void> insertQuestionTransaction(List<Question> questions) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final question in questions) {
        final questionJson = question.toJson();
        txn.insert(_tblQuestions, questionJson);
      }
    });
  }

  Future<void> insertCategoryTransaction(List<Category> categories) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final category in categories) {
        final categoryJson = category.toJson();
        txn.insert(_tblCategories, categoryJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getQuestionCache() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblQuestions,
    );
    return results;
  }

  Future<List<Map<String, dynamic>>> getCategoryCache() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCategories,
    );
    return results;
  }

  Future<int> clearQuestionCache() async {
    final db = await database;
    return await db!.delete(
      _tblQuestions,
    );
  }

  Future<int> clearCategoryCache() async {
    final db = await database;
    return await db!.delete(
      _tblCategories,
    );
  }
}
