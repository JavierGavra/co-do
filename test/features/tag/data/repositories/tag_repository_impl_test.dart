import 'package:codo/core/error/exceptions.dart';
import 'package:codo/core/error/failures.dart';
import 'package:codo/features/tag/data/datasource/tag_local_data_source.dart';
import 'package:codo/features/tag/data/models/tag_model.dart';
import 'package:codo/features/tag/data/repositories/tag_repository_impl.dart';
import 'package:codo/features/tag/domain/entities/tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tag_repository_impl_test.mocks.dart';

@GenerateMocks([TagLocalDataSource])
void main() {
  late MockTagLocalDataSource mockLocalDataSource;
  late TagRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockTagLocalDataSource();
    repository = TagRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tTagModel = TagModel(id: 1, title: 'Kuliah', backgroundHex: '#FF5733');
  const List<TagModel> tTagList = [tTagModel];

  // ─── getTags ────────────────────────────────────────────────────────────

  group('getTags', () {
    test('harus mengembalikan Right(List<Tag>) ketika berhasil', () async {
      when(mockLocalDataSource.getTags()).thenAnswer((_) async => tTagList);

      final result = await repository.getTags();

      verify(mockLocalDataSource.getTags());
      expect(result, const Right<Failure, List<Tag>>(tTagList));
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.getTags()).thenThrow(CacheException());

      final result = await repository.getTags();

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── createTag ──────────────────────────────────────────────────────────

  group('createTag', () {
    const tTitle = 'Olahraga';
    const tBgHex = '#00FF00';

    test('harus memanggil insertTag dan mengembalikan Right ketika berhasil',
        () async {
      when(mockLocalDataSource.insertTag(tTitle, tBgHex))
          .thenAnswer((_) async {});

      final result = await repository.createTag(tTitle, tBgHex);

      verify(mockLocalDataSource.insertTag(tTitle, tBgHex));
      expect(result.isRight(), true);
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.insertTag(tTitle, tBgHex))
          .thenThrow(CacheException());

      final result = await repository.createTag(tTitle, tBgHex);

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── renameTag ──────────────────────────────────────────────────────────

  group('renameTag', () {
    const tId = 1;
    const tNewTitle = 'Olahraga Pagi';

    test('harus memanggil renameTag dan mengembalikan Right ketika berhasil',
        () async {
      when(mockLocalDataSource.renameTag(tId, tNewTitle))
          .thenAnswer((_) async {});

      final result = await repository.renameTag(tId, tNewTitle);

      verify(mockLocalDataSource.renameTag(tId, tNewTitle));
      expect(result.isRight(), true);
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.renameTag(tId, tNewTitle))
          .thenThrow(CacheException());

      final result = await repository.renameTag(tId, tNewTitle);

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── deleteTagOnly ──────────────────────────────────────────────────────

  group('deleteTagOnly', () {
    const tId = 1;

    test('harus memanggil deleteTagOnly dan mengembalikan Right ketika berhasil',
        () async {
      when(mockLocalDataSource.deleteTagOnly(tId)).thenAnswer((_) async {});

      final result = await repository.deleteTagOnly(tId);

      verify(mockLocalDataSource.deleteTagOnly(tId));
      expect(result.isRight(), true);
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.deleteTagOnly(tId)).thenThrow(CacheException());

      final result = await repository.deleteTagOnly(tId);

      expect(result, Left(CacheFailure()));
    });
  });

  // ─── deleteTagWithTasks ─────────────────────────────────────────────────

  group('deleteTagWithTasks', () {
    const tId = 1;

    test(
        'harus memanggil deleteTagWithTasks dan mengembalikan Right ketika berhasil',
        () async {
      when(mockLocalDataSource.deleteTagWithTasks(tId))
          .thenAnswer((_) async {});

      final result = await repository.deleteTagWithTasks(tId);

      verify(mockLocalDataSource.deleteTagWithTasks(tId));
      expect(result.isRight(), true);
    });

    test('harus mengembalikan Left(CacheFailure) ketika terjadi exception',
        () async {
      when(mockLocalDataSource.deleteTagWithTasks(tId))
          .thenThrow(CacheException());

      final result = await repository.deleteTagWithTasks(tId);

      expect(result, Left(CacheFailure()));
    });
  });
}
