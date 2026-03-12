import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class PostTask implements UseCase<bool, PostTaskParams> {
  final TaskRepository repository;

  const PostTask({required this.repository});

  @override
  Future<Either<Failure, bool>> call(PostTaskParams params) {
    return repository.postTask(params.task);
  }
}

class PostTaskParams extends Equatable {
  final Task task;

  const PostTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
