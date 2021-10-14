import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorite = 'favorites';

  Future<Database> _initialDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/laporhoax.db',
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tblFavorite (
        id TEXT PRIMARY KEY,
        name TEXT,
        
        )''');
      },
      version: 1,
    );
    return db;
  }
}
