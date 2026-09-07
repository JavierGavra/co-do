import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failures.dart';
import "../entities/task.dart";

abstract interface class TaskRepository {
  Future<Either<Failure, List<Task>>> getMyDay();
  Future<Either<Failure, List<Task>>> getAllTasks();
  Future<Either<Failure, List<Task>>> getTasksByTag(int id);
  Future<Either<Failure, bool>> createTask(Task task);
  Future<Either<Failure, bool>> deleteTask(int id);
  Future<Either<Failure, bool>> taskChecked(int id, bool status);
}
