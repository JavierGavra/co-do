import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("codo.db");
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(30) NOT NULL,
        background_hex TEXT NOT NULL,
        background_dark_status BOOLEAN NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        due_date_time DATETIME,
        note TEXT,
        status BOOLEAN DEFAULT FALSE
      )
    ''');

    await db.execute('''
      CREATE TABLE task_tags (
        task_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (task_id, tag_id),
        FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tagss(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertTag({
    required String title,
    required String backgroundHex,
    required bool isBackgroundDark,
  }) async {
    final db = await instance.database;
    return await db.insert("tags", {
      'title': title,
      'background_hex': backgroundHex,
      'background_dark_status': isBackgroundDark,
    });
  }
}
