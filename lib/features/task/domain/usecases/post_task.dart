import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask implements UseCase<bool, CreateTaskParams> {
  final TaskRepository repository;

  const CreateTask({required this.repository});

  @override
  Future<Either<Failure, bool>> call(CreateTaskParams params) {
    return repository.createTask(params.task);
  }
}

class CreateTaskParams extends Equatable {
  final Task task;

  const CreateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
