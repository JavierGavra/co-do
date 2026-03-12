import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../repositories/tag_repository.dart';

class DeleteTag implements UseCase<bool, DeleteTagParams> {
  final TagRepository repository;

  const DeleteTag({required this.repository});

  @override
  Future<Either<Failure, bool>> call(DeleteTagParams params) {
    return repository.deleteTag(params.id);
  }
}

class DeleteTagParams extends Equatable {
  final int id;

  const DeleteTagParams({required this.id});

  @override
  List<Object> get props => [id];
}
