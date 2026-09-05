import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/tag.dart';
import '../../domain/repositories/tag_repository.dart';
import '../datasource/tag_local_data_source.dart';

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource localDataSource;

  const TagRepositoryImpl({required this.localDataSource});

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

  @override
  Future<Either<Failure, void>> deleteTagOnly(int id) async {
    try {
      await localDataSource.deleteTagOnly(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTagWithTasks(int id) async {
    try {
      await localDataSource.deleteTagWithTasks(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> renameTag(int id, String newTitle) async {
    try {
      await localDataSource.renameTag(id, newTitle);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
