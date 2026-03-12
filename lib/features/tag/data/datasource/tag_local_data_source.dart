import 'package:sqflite/sqflite.dart';

import 'package:codo/core/error/exceptions.dart';
import '../models/tag_model.dart';

abstract interface class TagLocalDataSource {
  Future<List<TagModel>> getTags();
  Future<bool> postTag(TagModel tag);
  Future<bool> deleteTag(int id);
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  final Database database;

  const TagLocalDataSourceImpl({required this.database});

  @override
  Future<bool> deleteTag(int id) async {
    try {
      await database.delete('tags', where: 'id = $id');
      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<TagModel>> getTags() async {
    try {
      final data = await database.query('tags');
      return data.map((x) => TagModel.fromJson(x)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> postTag(TagModel tag) async {
    try {
      await database.insert('tags', tag.toJson());
      return true;
    } catch (e) {
      throw CacheException();
    }
  }
}
