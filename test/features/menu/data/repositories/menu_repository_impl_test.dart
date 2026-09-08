import 'package:codo/core/error/exceptions.dart';
import 'package:codo/core/error/failures.dart';
import 'package:codo/features/menu/data/datasources/menu_local_datasource.dart';
import 'package:codo/features/menu/data/models/tag_menu_item_model.dart';
import 'package:codo/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:codo/features/menu/domain/entities/tag_menu_item.dart';
import 'package:codo/features/menu/domain/usecases/update_tags_order.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'menu_repository_impl_test.mocks.dart';

@GenerateMocks([MenuLocalDatasource])
void main() {
  late MockMenuLocalDatasource mockLocalDataSource;
  late MenuRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockMenuLocalDatasource();
    repository = MenuRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tTagModel = TagMenuItemModel(
    id: 1,
    title: 'Kuliah',
    backgroundHex: '#FF5733',
    taskAmount: 3,
  );
  const List<TagMenuItemModel> tTagList = [tTagModel];

  // ─── getTaskAmount ──────────────────────────────────────────────────────

  group('getTaskAmount', () {
    const tAmount = 10;

    test('harus mengembalikan Right(int) ketika berhasil', () async {
      when(mockLocalDataSource.getTaskAmount())
          .thenAnswer((_) async => tAmount);

      final result = await repository.getTaskAmount();

      verify(mockLocalDataSource.getTaskAmount());
      expect(result, const Right<Failure, int>(tAmount));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.getTaskAmount()).thenThrow(CacheException());

      final result = await repository.getTaskAmount();

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── getMyDayAmount ─────────────────────────────────────────────────────

  group('getMyDayAmount', () {
    const tAmount = 5;

    test('harus mengembalikan Right(int) ketika berhasil', () async {
      when(mockLocalDataSource.getMyDayAmount())
          .thenAnswer((_) async => tAmount);

      final result = await repository.getMyDayAmount();

      verify(mockLocalDataSource.getMyDayAmount());
      expect(result, const Right<Failure, int>(tAmount));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.getMyDayAmount()).thenThrow(CacheException());

      final result = await repository.getMyDayAmount();

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── getTagMenuItems ────────────────────────────────────────────────────

  group('getTagMenuItems', () {
    test('harus mengembalikan Right(List<TagMenuItem>) ketika berhasil',
        () async {
      when(mockLocalDataSource.getTags()).thenAnswer((_) async => tTagList);

      final result = await repository.getTagMenuItems();

      verify(mockLocalDataSource.getTags());
      expect(result, const Right<Failure, List<TagMenuItem>>(tTagList));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.getTags()).thenThrow(CacheException());

      final result = await repository.getTagMenuItems();

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── updateTagsOrder ────────────────────────────────────────────────────

  group('updateTagsOrder', () {
    const tParams = UpdateTagsOrderParams(tags: [tTagModel]);

    test('harus memanggil updateTagsOrder dan mengembalikan Right ketika berhasil',
        () async {
      when(mockLocalDataSource.updateTagsOrder(any)).thenAnswer((_) async {});

      final result = await repository.updateTagsOrder(tParams);

      verify(mockLocalDataSource.updateTagsOrder(any));
      expect(result.isRight(), true);
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.updateTagsOrder(any)).thenThrow(CacheException());

      final result = await repository.updateTagsOrder(tParams);

      expect(result, Left(CacheFailure()));
    });
  });
}
