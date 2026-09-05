import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import 'package:codo/features/tag/domain/repositories/tag_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DeleteTagWithTasks implements UseCase<void, DeleteTagWithTasksParams> {
  final TagRepository _repository;

  const DeleteTagWithTasks(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteTagWithTasksParams params) {
    return _repository.deleteTagWithTasks(params.id);
  }
}

class DeleteTagWithTasksParams extends Equatable {
  final int id;

  const DeleteTagWithTasksParams({required this.id});

  @override
  List<Object> get props => [id];
}
