import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  const TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> deleteTask(int id) async {
    try {
      return Right(await localDataSource.deleteTask(id));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getAllTasks() async {
    try {
      return Right(await localDataSource.getAllTasks());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getMyDay() async {
    try {
      return Right(await localDataSource.getMyDay());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByTag(int id) async {
    try {
      return Right(await localDataSource.getTasksByCategory(id));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createTask(Task task) async {
    try {
      return Right(
        await localDataSource.insertTask(TaskModel.fromEntity(task)),
      );
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> taskChecked(int id, bool status) async {
    try {
      return Right(await localDataSource.taskChecked(id, status));
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
