import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/exceptions.dart';
import '../models/tag_menu_item_model.dart';

abstract interface class MenuLocalDatasource {
  Future<int> getTaskAmount();
  Future<int> getMyDayAmount();
  Future<List<TagMenuItemModel>> getTags();
  Future<void> insertTag(String title, String backgroundHex);
}

class MenuLocalDatasourceImpl implements MenuLocalDatasource {
  final Database database;

  const MenuLocalDatasourceImpl({required this.database});

  @override
  Future<int> getTaskAmount() async {
    try {
      final data = await database.rawQuery(
        'SELECT COUNT(tasks.id) as amount FROM tasks',
      );
      return int.parse(data[0]['amount'].toString());
    } catch (e) {
      debugPrint('$e');
      throw CacheException();
    }
  }

  @override
  Future<int> getMyDayAmount() async {
    try {
      final now = DateTime.now();
      final endOfDateRange = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
      ).add(const Duration(days: 3));

      final data = await database.rawQuery(
        'SELECT COUNT(tasks.id) as amount FROM tasks WHERE due_date_time <= ? OR due_date_time IS NULL',
        [endOfDateRange.toIso8601String()],
      );
      return int.parse(data[0]['amount'].toString());
    } catch (e) {
      debugPrint('$e');
      throw CacheException();
    }
  }

  @override
  Future<List<TagMenuItemModel>> getTags() async {
    try {
      final data = await database.rawQuery('''
      SELECT 
        tags.*,
        IFNULL(COUNT(tasks.id), 0) AS task_amount
      FROM tags
      LEFT JOIN tasks ON tags.id = tasks.tag_id
      GROUP BY tags.id;
      ''');
      return data.map((row) => TagMenuItemModel.fromMap(row)).toList();
    } catch (e) {
      debugPrint('$e');
      throw CacheException();
    }
  }

  @override
  Future<void> insertTag(String title, String backgroundHex) async {
    try {
      await database.insert('tags', {
        'title': title,
        'background_hex': backgroundHex,
      });
    } catch (e) {
      debugPrint('$e');
      throw CacheException();
    }
  }
}
