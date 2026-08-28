import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/tag_menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_local_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuLocalDatasource localDataSource;

  MenuRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> createTag(
    String title,
    String backgroundHex,
  ) async {
    try {
      await localDataSource.insertTag(title, backgroundHex);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getMyDayAmount() async {
    try {
      final amount = await localDataSource.getMyDayAmount();
      return Right(amount);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<TagMenuItem>>> getTagMenuItems() async {
    try {
      final tags = await localDataSource.getTags();
      return Right(tags);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getTaskAmount() async {
    try {
      final amount = await localDataSource.getTaskAmount();
      return Right(amount);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
