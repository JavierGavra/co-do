import 'package:sqflite/sqflite.dart';

Future<void> databaseTableSetup(Database db) async {
  await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(30) NOT NULL,
        background_hex TEXT NOT NULL
      )
    ''');

  await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        due_date_time DATETIME,
        note TEXT,
        status BOOLEAN DEFAULT FALSE,
        tag_id INTEGER,
        FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
      )
    ''');
}
