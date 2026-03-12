import 'package:dartz/dartz.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../repositories/tag_repository.dart';
import '../entities/tag.dart';

class GetTags implements UseCase<List<Tag>, NoParams> {
  final TagRepository repository;

  const GetTags({required this.repository});

  @override
  Future<Either<Failure, List<Tag>>> call(NoParams params) {
    return repository.getTags();
  }
}
