import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/tag.dart';
import '../../domain/repositories/tag_repository.dart';
import '../datasource/tag_local_data_source.dart';

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
  Future<Either<Failure, void>> createTag(
    String title,
    String backgroundHex,
  ) async {
    try {
      return Right(await localDataSource.insertTag(title, backgroundHex));
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
