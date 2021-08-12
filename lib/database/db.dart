import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return database;

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'crypto.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(db, version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_history);

    await db.insert('count', {'amount': 0});
  }

  String get _account => ''' 
    CREATE TABLE account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL
    );
  ''';

  String get _wallet => ''' 
    CREATE TABLE wallet (
      initials TEXT PRIMARY KEY,
      coin TEXT,
      quantity TEXT
    );
  ''';

  String get _history => ''' 
    CREATE TABLE wallet (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      operation_date INT,
      operation_type TEXT,
      coin TEXT,
      initials TEXT,
      value REAL,
      quantity TEXT
    );
  ''';
}
