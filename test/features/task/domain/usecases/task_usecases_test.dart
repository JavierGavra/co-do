import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import 'package:codo/features/task/domain/entities/task.dart';
import 'package:codo/features/task/domain/repositories/task_repository.dart';
import 'package:codo/features/task/domain/usecases/delete_task.dart';
import 'package:codo/features/task/domain/usecases/get_all_tasks.dart';
import 'package:codo/features/task/domain/usecases/get_my_day.dart';
import 'package:codo/features/task/domain/usecases/get_tasks_by_tag.dart';
import 'package:codo/features/task/domain/usecases/post_task.dart';
import 'package:codo/features/task/domain/usecases/task_checked.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_usecases_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  const tTask = Task(id: 1, title: 'Belajar Flutter', status: false);
  const tTaskList = <Task>[tTask];

  // ─── GetAllTasks ───────────────────────────────────────────────────────

  group('GetAllTasks', () {
    test('harus memanggil repository.getAllTasks()', () async {
      when(mockRepository.getAllTasks())
          .thenAnswer((_) async => const Right(tTaskList));

      final usecase = GetAllTasks(repository: mockRepository);
      final result = await usecase(NoParams());

      verify(mockRepository.getAllTasks());
      expect(result, const Right<Failure, List<Task>>(tTaskList));
    });
  });

  // ─── GetMyDay ──────────────────────────────────────────────────────────

  group('GetMyDay', () {
    test('harus memanggil repository.getMyDay()', () async {
      when(mockRepository.getMyDay())
          .thenAnswer((_) async => const Right(tTaskList));

      final usecase = GetMyDay(repository: mockRepository);
      final result = await usecase(NoParams());

      verify(mockRepository.getMyDay());
      expect(result, const Right<Failure, List<Task>>(tTaskList));
    });
  });

  // ─── GetTasksByTag ─────────────────────────────────────────────────────

  group('GetTasksByTag', () {
    const tTagId = 5;

    test('harus memanggil repository.getTasksByTag() dengan id yang benar',
        () async {
      when(mockRepository.getTasksByTag(tTagId))
          .thenAnswer((_) async => const Right(tTaskList));

      final usecase = GetTasksByTag(repository: mockRepository);
      final result = await usecase(const GetTasksByTagParams(id: tTagId));

      verify(mockRepository.getTasksByTag(tTagId));
      expect(result, const Right<Failure, List<Task>>(tTaskList));
    });
  });

  // ─── CreateTask ────────────────────────────────────────────────────────

  group('CreateTask', () {
    test('harus memanggil repository.createTask() dengan task yang benar',
        () async {
      when(mockRepository.createTask(tTask))
          .thenAnswer((_) async => const Right(true));

      final usecase = CreateTask(repository: mockRepository);
      final result = await usecase(const CreateTaskParams(task: tTask));

      verify(mockRepository.createTask(tTask));
      expect(result, const Right<Failure, bool>(true));
    });
  });

  // ─── DeleteTask ────────────────────────────────────────────────────────

  group('DeleteTask', () {
    const tId = 1;

    test('harus memanggil repository.deleteTask() dengan id yang benar',
        () async {
      when(mockRepository.deleteTask(tId))
          .thenAnswer((_) async => const Right(true));

      final usecase = DeleteTask(repository: mockRepository);
      final result = await usecase(const DeleteTaskParams(id: tId));

      verify(mockRepository.deleteTask(tId));
      expect(result, const Right<Failure, bool>(true));
    });
  });

  // ─── TaskChecked ───────────────────────────────────────────────────────

  group('TaskChecked', () {
    const tId = 1;
    const tStatus = true;

    test('harus memanggil repository.taskChecked() dengan id dan status benar',
        () async {
      when(mockRepository.taskChecked(tId, tStatus))
          .thenAnswer((_) async => const Right(true));

      final usecase = TaskChecked(repository: mockRepository);
      final result = await usecase(
        const TaskCheckedParams(id: tId, status: tStatus),
      );

      verify(mockRepository.taskChecked(tId, tStatus));
      expect(result, const Right<Failure, bool>(true));
    });
  });
}
