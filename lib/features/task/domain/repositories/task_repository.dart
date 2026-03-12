import 'package:dartz/dartz.dart' hide Task;

import 'package:codo/core/error/failures.dart';
import "../entities/task.dart";

abstract interface class TaskRepository {
  Future<Either<Failure, List<Task>>> getMyDay();
  Future<Either<Failure, List<Task>>> getAllTasks();
  Future<Either<Failure, List<Task>>> getTasksByTag(int id);
  Future<Either<Failure, int>> getMyDayAmmount();
  Future<Either<Failure, int>> getTaskAmount();
  Future<Either<Failure, bool>> postTask(Task task);
  Future<Either<Failure, bool>> deleteTask(int id);
  Future<Either<Failure, bool>> taskChecked(int id, bool status);
}
