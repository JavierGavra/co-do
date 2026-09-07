import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/tag_repository.dart';

class RenameTag implements UseCase<void, RenameTagParams> {
  final TagRepository repository;

  const RenameTag(this.repository);

  @override
  Future<Either<Failure, void>> call(RenameTagParams params) {
    return repository.renameTag(params.tagId, params.newTitle);
  }
}

class RenameTagParams extends Equatable {
  final int tagId;
  final String newTitle;

  const RenameTagParams({required this.tagId, required this.newTitle});

  @override
  List<Object?> get props => throw UnimplementedError();
}
