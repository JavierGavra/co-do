import 'package:codo/core/database/database_helper.dart';
import 'package:codo/features/menu/models/tag.dart';

class LocalService {
  final _db = DatabaseHelper.instance;

  Future<int> createTag(Tag tag) async {
    final db = await _db.database;
    return await db.insert('tags', {
      'title': tag.title,
      'background_hex': tag.backgroundHex,
    });
  }

  Future<List<Tag>> getTags() async {
    final db = await _db.database;
    final data = await db.query('tags');
    return data.map((e) => Tag.fromMap(e)).toList();
  }

  Future<int> getTaskAmount() async {
    final db = await _db.database;
    final data = await db.rawQuery(
      'SELECT COUNT(tasks.id) as amount FROM tasks',
    );
    return int.parse(data[0]['amount'].toString());
  }

  Future<int> getMyDayAmount() async {
    final db = await _db.database;
    final now = DateTime.now();
    final endOfDateRange = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).add(const Duration(days: 3));

    final data = await db.rawQuery(
      'SELECT COUNT(tasks.id) as amount FROM tasks WHERE due_date_time <= ? OR due_date_time IS NULL',
      [endOfDateRange.toIso8601String()],
    );
    return int.parse(data[0]['amount'].toString());
  }
}
