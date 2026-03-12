import 'package:dartz/dartz.dart';

import 'package:codo/core/error/failures.dart';
import '../entities/tag.dart';

abstract interface class TagRepository {
  Future<Either<Failure, List<Tag>>> getTags();
  Future<Either<Failure, bool>> postTag(Tag tag);
  Future<Either<Failure, bool>> deleteTag(int id);
}
