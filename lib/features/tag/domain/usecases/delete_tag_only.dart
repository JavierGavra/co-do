import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../repositories/tag_repository.dart';

class DeleteTagOnly implements UseCase<void, DeleteTagOnlyParams> {
  final TagRepository repository;

  const DeleteTagOnly({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteTagOnlyParams params) {
    return repository.deleteTagOnly(params.id);
  }
}

class DeleteTagOnlyParams extends Equatable {
  final int id;

  const DeleteTagOnlyParams({required this.id});

  @override
  List<Object> get props => [id];
}
