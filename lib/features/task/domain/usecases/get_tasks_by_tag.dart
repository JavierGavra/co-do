import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksByTag implements UseCase<List<Task>, GetTasksByTagParams> {
  final TaskRepository repository;

  const GetTasksByTag({required this.repository});

  @override
  Future<Either<Failure, List<Task>>> call(GetTasksByTagParams params) {
    return repository.getTasksByTag(params.id);
  }
}

class GetTasksByTagParams extends Equatable {
  final int id;

  const GetTasksByTagParams({required this.id});

  @override
  List<Object> get props => [id];
}
