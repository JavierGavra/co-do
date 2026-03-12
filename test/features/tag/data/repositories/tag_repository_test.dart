import 'package:codo/features/tag/data/datasource/tag_local_data_source.dart';
import 'package:codo/features/tag/data/models/tag_model.dart';
import 'package:codo/features/tag/data/repositories/tag_repository_impl.dart';
import 'package:codo/features/tag/domain/entities/tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../core/database/database_setup.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Database database;
  late TagRepositoryImpl repository;

  final tTag = Tag(title: "Tag 1", backgroundHex: 'FFFFFF');
  final tTagModel = TagModel(id: 1, title: "Tag 1", backgroundHex: 'FFFFFF');

  setUp(() async {
    database = await openDatabase(inMemoryDatabasePath);

    await databaseTableSetup(database);

    repository = TagRepositoryImpl(
      localDataSource: TagLocalDataSourceImpl(database: database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('Tag Repository', () {
    test('postTag()', () async {
      final response = await repository.postTag(tTag);
      return response.fold((l) => fail(l.toString()), (r) => expect(r, true));
    });

    test('getTags()', () async {
      await repository.postTag(tTag);
      final response = await repository.getTags();
      return response.fold(
        (l) => fail(l.toString()),
        (r) => expect(r, [tTagModel]),
      );
    });

    test('deleteTags()', () async {
      await repository.postTag(tTag);
      final response = await repository.deleteTag(1);
      return response.fold((l) => fail(l.toString()), (r) => expect(r, true));
    });
  });
}
