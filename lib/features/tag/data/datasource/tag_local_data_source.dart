import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/exceptions.dart';
import '../models/tag_model.dart';

abstract interface class TagLocalDataSource {
  Future<List<TagModel>> getTags();
  Future<void> insertTag(String title, String backgroundHex);
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
  Future<void> insertTag(String title, String backgroundHex) async {
    try {
      final maxOrderIndex = await database.rawQuery(
        'SELECT IFNULL(MAX(order_index), -1) as max_index FROM tags',
      );

      final newOrderIndex = maxOrderIndex.isNotEmpty
          ? int.parse(maxOrderIndex[0]['max_index'].toString()) + 1
          : 0;

      await database.insert('tags', {
        'title': title,
        'background_hex': backgroundHex,
        'order_index': newOrderIndex,
      });
    } catch (e) {
      debugPrint('$e');
      throw CacheException();
    }
  }
}
