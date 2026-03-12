import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../repositories/task_repository.dart';

class DeleteTask implements UseCase<bool, DeleteTaskParams> {
  final TaskRepository repository;

  const DeleteTask({required this.repository});

  @override
  Future<Either<Failure, bool>> call(DeleteTaskParams params) {
    return repository.deleteTask(params.id);
  }
}

class DeleteTaskParams extends Equatable {
  final int id;

  const DeleteTaskParams({required this.id});

  @override
  List<Object> get props => [id];
}
