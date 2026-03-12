import 'package:dartz/dartz.dart';

import 'package:codo/core/error/failures.dart';
import '../../domain/entities/tag.dart';
import '../../domain/repositories/tag_repository.dart';
import '../datasource/tag_local_data_source.dart';
import '../models/tag_model.dart';

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource localDataSource;

  const TagRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> deleteTag(int id) async {
    try {
      return Right(await localDataSource.deleteTag(id));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getTags() async {
    try {
      return Right(await localDataSource.getTags());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postTag(Tag tag) async {
    try {
      return Right(await localDataSource.postTag(TagModel.fromEntity(tag)));
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
