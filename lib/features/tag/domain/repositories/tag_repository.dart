import 'package:dartz/dartz.dart';

import 'package:codo/core/error/failures.dart';
import '../entities/tag.dart';

abstract interface class TagRepository {
  Future<Either<Failure, List<Tag>>> getTags();
  Future<Either<Failure, void>> createTag(String title, String backgroundHex);
  Future<Either<Failure, void>> renameTag(int id, String newTitle);
  Future<Either<Failure, void>> deleteTagOnly(int id);
  Future<Either<Failure, void>> deleteTagWithTasks(int id);
}
