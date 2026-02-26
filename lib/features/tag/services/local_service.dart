import 'package:codo/core/database/database_helper.dart';
import 'package:codo/features/tag/models/tag.dart';

class LocalService {
  final _db = DatabaseHelper.instance;

  Future<List<Tag>> getTags() async {
    final db = await _db.database;
    final data = await db.query('tags');
    return data.map((e) => Tag.fromMap(e)).toList();
  }
}
