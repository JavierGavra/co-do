import 'package:codo/core/database/database_helper.dart';
import 'package:codo/features/task/models/task.dart';

class LocalService {
  final _db = DatabaseHelper.instance;

  Future<int> insertTask(Task task) async {
    final db = await _db.database;
    return await db.insert("tasks", task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    final db = await _db.database;
    final data = await db.query("tasks", orderBy: "due_date_time ASC");
    return List.generate(data.length, (index) => Task.fromMap(data[index]));
  }

  Future<List<Task>> getMyDayTasks() async {
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

    final data = await db.query(
      "tasks",
      where: "due_date_time <= ? OR due_date_time IS NULL",
      whereArgs: [endOfDateRange.toIso8601String()],
      orderBy: "due_date_time ASC",
    );
    return List.generate(data.length, (index) => Task.fromMap(data[index]));
  }

  Future<int> deleteTask(int id) async {
    final db = await _db.database;
    return await db.delete('tasks', where: 'id = $id');
  }

  Future<int> taskChecked(int id, bool status) async {
    final db = await _db.database;
    return await db.update('tasks', {"status": status}, where: 'id = $id');
  }
}
