import 'package:codo/features/task/data/datasources/task_local_data_source.dart';
import 'package:codo/features/task/data/models/task_model.dart';
import 'package:codo/features/task/data/repositories/task_repository_impl.dart';
import 'package:codo/features/task/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../core/database/database_setup.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Database database;
  late TaskRepositoryImpl repository;

  final now = DateTime.now();
  final tTask = Task(title: "Tugas 1", dueDate: now);
  final tTaskModel = TaskModel(
    id: 1,
    title: "Tugas 1",
    dueDate: now,
    status: false,
  );

  setUp(() async {
    database = await openDatabase(inMemoryDatabasePath);

    await databaseTableSetup(database);

    repository = TaskRepositoryImpl(
      localDataSource: TaskLocalDataSourceImpl(database: database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group("Task Repository", () {
    test("postTask()", () async {
      final response = await repository.postTask(tTask);
      response.fold((l) => fail(l.toString()), (r) => expect(r, true));
    });

    test("getAllTasks()", () async {
      await repository.postTask(tTask);
      final response = await repository.getAllTasks();
      response.fold((l) => fail(l.toString()), (r) => expect(r, [tTaskModel]));
    });

    test("getMyDay()", () async {
      await repository.postTask(tTask);
      final response = await repository.getMyDay();
      response.fold((l) => fail(l.toString()), (r) => expect(r, [tTaskModel]));
    });

    test("deleteTask()", () async {
      await repository.postTask(tTask);
      final response = await repository.deleteTask(1);
      response.fold((l) => fail(l.toString()), (r) => expect(r, true));
    });
  });
}
