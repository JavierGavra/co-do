import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

class PostTag implements UseCase<bool, PostTagParams> {
  final TagRepository repository;

  const PostTag({required this.repository});

  @override
  Future<Either<Failure, bool>> call(PostTagParams params) {
    return repository.postTag(params.tag);
  }
}

class PostTagParams extends Equatable {
  final Tag tag;

  const PostTagParams({required this.tag});

  @override
  List<Object> get props => [tag];
}
