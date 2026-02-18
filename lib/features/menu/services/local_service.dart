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
}
