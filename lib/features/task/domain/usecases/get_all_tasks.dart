import 'package:dartz/dartz.dart' hide Task;

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/task_repository.dart';
import '../entities/task.dart';

class GetAllTasks implements UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  const GetAllTasks({required this.repository});

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) {
    return repository.getAllTasks();
  }
}
