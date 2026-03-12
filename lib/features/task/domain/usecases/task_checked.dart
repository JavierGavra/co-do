import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../repositories/task_repository.dart';

class TaskChecked implements UseCase<bool, TaskCheckedParams> {
  final TaskRepository repository;

  const TaskChecked({required this.repository});

  @override
  Future<Either<Failure, bool>> call(TaskCheckedParams params) {
    return repository.taskChecked(params.id, params.status);
  }
}

class TaskCheckedParams extends Equatable {
  final int id;
  final bool status;

  const TaskCheckedParams({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}
