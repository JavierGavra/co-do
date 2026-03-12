import 'package:sqflite/sqflite.dart';

import 'package:codo/core/error/exceptions.dart';
import '../models/task_model.dart';

abstract interface class TaskLocalDataSource {
  Future<List<TaskModel>> getMyDay();
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getTasksByCategory(int id);
  Future<int> getMyDayAmount();
  Future<int> getTaskAmount();
  Future<bool> postTask(TaskModel task);
  Future<bool> deleteTask(int id);
  Future<bool> taskChecked(int id, bool status);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Database database;

  const TaskLocalDataSourceImpl({required this.database});

  @override
  Future<List<TaskModel>> getMyDay() async {
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
        '''
        SELECT 
          tasks.*,
          tags.id AS tag_id,
          tags.title AS tag_title,
          tags.background_hex AS tag_background_hex
        FROM tasks
        LEFT JOIN tags ON tasks.tag_id = tags.id
        WHERE 
          tasks.due_date_time <= ? 
          OR tasks.due_date_time IS NULL
        ORDER BY tasks.due_date_time ASC
        ''',
        [endOfDateRange.toIso8601String()],
      );
      return data.map((x) => TaskModel.fromJson(x)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final data = await database.rawQuery('''
        SELECT 
          tasks.*,
          tags.id AS tag_id,
          tags.title AS tag_title,
          tags.background_hex AS tag_background_hex
        FROM tasks
        LEFT JOIN tags ON tasks.tag_id = tags.id
        ORDER BY tasks.due_date_time ASC
      ''');
      return data.map((x) => TaskModel.fromJson(x)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<TaskModel>> getTasksByCategory(int id) {
    throw UnimplementedError();
  }

  @override
  Future<bool> postTask(TaskModel task) async {
    try {
      await database.insert("tasks", task.toJson());
      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> deleteTask(int id) async {
    try {
      await database.delete('tasks', where: 'id = $id');
      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> taskChecked(int id, bool status) async {
    try {
      await database.update('tasks', {"status": status}, where: 'id = $id');
      return true;
    } catch (e) {
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
      throw CacheException();
    }
  }

  @override
  Future<int> getTaskAmount() async {
    try {
      final data = await database.rawQuery(
        'SELECT COUNT(tasks.id) as amount FROM tasks',
      );
      return int.parse(data[0]['amount'].toString());
    } catch (e) {
      throw CacheException();
    }
  }
}
