import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import 'package:codo/features/tag/domain/entities/tag.dart';
import 'package:codo/features/tag/domain/repositories/tag_repository.dart';
import 'package:codo/features/tag/domain/usecases/create_tag.dart';
import 'package:codo/features/tag/domain/usecases/delete_tag_only.dart';
import 'package:codo/features/tag/domain/usecases/delete_tag_with_tasks.dart';
import 'package:codo/features/tag/domain/usecases/get_tags.dart';
import 'package:codo/features/tag/domain/usecases/rename_tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tag_usecases_test.mocks.dart';

@GenerateMocks([TagRepository])
void main() {
  late MockTagRepository mockRepository;

  setUp(() {
    mockRepository = MockTagRepository();
  });

  const tTag = Tag(id: 1, title: 'Kuliah', backgroundHex: '#FF5733');
  const tTagList = <Tag>[tTag];

  // ─── GetTags ────────────────────────────────────────────────────────────

  group('GetTags', () {
    test('harus memanggil repository.getTags()', () async {
      when(
        mockRepository.getTags(),
      ).thenAnswer((_) async => const Right(tTagList));

      final usecase = GetTags(repository: mockRepository);
      final result = await usecase(NoParams());

      verify(mockRepository.getTags());
      expect(result, const Right<Failure, List<Tag>>(tTagList));
    });
  });

  // ─── CreateTag ──────────────────────────────────────────────────────────

  group('CreateTag', () {
    const tTitle = 'Olahraga';
    const tBgHex = '#00FF00';

    test(
      'harus memanggil repository.createTag() dengan params yang benar',
      () async {
        when(
          mockRepository.createTag(tTitle, tBgHex),
        ).thenAnswer((_) async => const Right(null));

        final usecase = CreateTag(mockRepository);
        final result = await usecase(
          const CreateTagParams(title: tTitle, backgroundHex: tBgHex),
        );

        verify(mockRepository.createTag(tTitle, tBgHex));
        expect(result.isRight(), true);
      },
    );
  });

  // ─── RenameTag ──────────────────────────────────────────────────────────

  group('RenameTag', () {
    const tId = 1;
    const tNewTitle = 'Olahraga Pagi';

    test(
      'harus memanggil repository.renameTag() dengan params yang benar',
      () async {
        when(
          mockRepository.renameTag(tId, tNewTitle),
        ).thenAnswer((_) async => const Right(null));

        final usecase = RenameTag(mockRepository);
        final result = await usecase(
          const RenameTagParams(tagId: tId, newTitle: tNewTitle),
        );

        verify(mockRepository.renameTag(tId, tNewTitle));
        expect(result.isRight(), true);
      },
    );
  });

  // ─── DeleteTagOnly ──────────────────────────────────────────────────────

  group('DeleteTagOnly', () {
    const tId = 1;

    test(
      'harus memanggil repository.deleteTagOnly() dengan id yang benar',
      () async {
        when(
          mockRepository.deleteTagOnly(tId),
        ).thenAnswer((_) async => const Right(null));

        final usecase = DeleteTagOnly(repository: mockRepository);
        final result = await usecase(const DeleteTagOnlyParams(id: tId));

        verify(mockRepository.deleteTagOnly(tId));
        expect(result.isRight(), true);
      },
    );
  });

  // ─── DeleteTagWithTasks ─────────────────────────────────────────────────

  group('DeleteTagWithTasks', () {
    const tId = 1;

    test(
      'harus memanggil repository.deleteTagWithTasks() dengan id yang benar',
      () async {
        when(
          mockRepository.deleteTagWithTasks(tId),
        ).thenAnswer((_) async => const Right(null));

        final usecase = DeleteTagWithTasks(mockRepository);
        final result = await usecase(const DeleteTagWithTasksParams(id: tId));

        verify(mockRepository.deleteTagWithTasks(tId));
        expect(result.isRight(), true);
      },
    );
  });
}
