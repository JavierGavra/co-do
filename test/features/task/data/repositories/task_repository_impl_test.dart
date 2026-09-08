import 'package:codo/core/error/exceptions.dart';
import 'package:codo/core/error/failures.dart';
import 'package:codo/features/task/data/datasources/task_local_data_source.dart';
import 'package:codo/features/task/data/models/task_model.dart';
import 'package:codo/features/task/data/repositories/task_repository_impl.dart';
import 'package:codo/features/task/domain/entities/task.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_repository_impl_test.mocks.dart';

@GenerateMocks([TaskLocalDataSource])
void main() {
  late MockTaskLocalDataSource mockLocalDataSource;
  late TaskRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tTaskModel = TaskModel(
    id: 1,
    title: 'Belajar Flutter',
    status: false,
  );
  const List<TaskModel> tTaskList = [tTaskModel];

  // ─── getAllTasks ────────────────────────────────────────────────────────

  group('getAllTasks', () {
    test('harus mengembalikan Right(List<Task>) ketika berhasil', () async {
      when(mockLocalDataSource.getAllTasks())
          .thenAnswer((_) async => tTaskList);

      final result = await repository.getAllTasks();

      verify(mockLocalDataSource.getAllTasks());
      expect(result, const Right<Failure, List<Task>>(tTaskList));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.getAllTasks()).thenThrow(CacheException());

      final result = await repository.getAllTasks();

      verify(mockLocalDataSource.getAllTasks());
      expect(result, Left(CacheFailure()));
    });
  });

  // ─── getMyDay ──────────────────────────────────────────────────────────

  group('getMyDay', () {
    test('harus mengembalikan Right(List<Task>) ketika berhasil', () async {
      when(mockLocalDataSource.getMyDay()).thenAnswer((_) async => tTaskList);

      final result = await repository.getMyDay();

      verify(mockLocalDataSource.getMyDay());
      expect(result, const Right<Failure, List<Task>>(tTaskList));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.getMyDay()).thenThrow(CacheException());

      final result = await repository.getMyDay();

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── getTasksByTag ─────────────────────────────────────────────────────

  group('getTasksByTag', () {
    const tTagId = 1;

    test('harus mengembalikan Right(List<Task>) ketika berhasil', () async {
      when(mockLocalDataSource.getTasksByCategory(tTagId))
          .thenAnswer((_) async => tTaskList);

      final result = await repository.getTasksByTag(tTagId);

      verify(mockLocalDataSource.getTasksByCategory(tTagId));
      expect(result, const Right<Failure, List<Task>>(tTaskList));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.getTasksByCategory(tTagId))
          .thenThrow(CacheException());

      final result = await repository.getTasksByTag(tTagId);

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── createTask ────────────────────────────────────────────────────────

  group('createTask', () {
    const tTask = Task(id: 1, title: 'Belajar Flutter', status: false);

    test('harus mengembalikan Right(true) ketika berhasil', () async {
      when(mockLocalDataSource.insertTask(any)).thenAnswer((_) async => true);

      final result = await repository.createTask(tTask);

      expect(result, const Right<Failure, bool>(true));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.insertTask(any)).thenThrow(CacheException());

      final result = await repository.createTask(tTask);

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── deleteTask ────────────────────────────────────────────────────────

  group('deleteTask', () {
    const tId = 1;

    test('harus mengembalikan Right(true) ketika berhasil', () async {
      when(mockLocalDataSource.deleteTask(tId)).thenAnswer((_) async => true);

      final result = await repository.deleteTask(tId);

      verify(mockLocalDataSource.deleteTask(tId));
      expect(result, const Right<Failure, bool>(true));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.deleteTask(tId)).thenThrow(CacheException());

      final result = await repository.deleteTask(tId);

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── taskChecked ───────────────────────────────────────────────────────

  group('taskChecked', () {
    const tId = 1;
    const tStatus = true;

    test('harus mengembalikan Right(true) ketika berhasil', () async {
      when(mockLocalDataSource.taskChecked(tId, tStatus))
          .thenAnswer((_) async => true);

      final result = await repository.taskChecked(tId, tStatus);

      verify(mockLocalDataSource.taskChecked(tId, tStatus));
      expect(result, const Right<Failure, bool>(true));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.taskChecked(tId, tStatus))
          .thenThrow(CacheException());

      final result = await repository.taskChecked(tId, tStatus);

      expect(result, Left(CacheFailure()));
    });
  });
}
