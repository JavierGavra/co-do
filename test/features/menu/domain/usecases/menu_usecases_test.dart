import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import 'package:codo/features/menu/domain/entities/tag_menu_item.dart';
import 'package:codo/features/menu/domain/repositories/menu_repository.dart';
import 'package:codo/features/menu/domain/usecases/get_my_day_amount.dart';
import 'package:codo/features/menu/domain/usecases/get_tag_menu_items.dart';
import 'package:codo/features/menu/domain/usecases/get_task_amount.dart';
import 'package:codo/features/menu/domain/usecases/update_tags_order.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'menu_usecases_test.mocks.dart';

@GenerateMocks([MenuRepository])
void main() {
  late MockMenuRepository mockRepository;

  setUp(() {
    mockRepository = MockMenuRepository();
  });

  const tTagMenuItem = TagMenuItem(
    id: 1,
    title: 'Kuliah',
    backgroundHex: '#FF5733',
    taskAmount: 3,
  );
  const tTagMenuList = <TagMenuItem>[tTagMenuItem];

  // ─── GetTaskAmount ──────────────────────────────────────────────────────

  group('GetTaskAmount', () {
    const tAmount = 10;

    test('harus memanggil repository.getTaskAmount()', () async {
      when(mockRepository.getTaskAmount())
          .thenAnswer((_) async => const Right(tAmount));

      final usecase = GetTaskAmount(mockRepository);
      final result = await usecase(NoParams());

      verify(mockRepository.getTaskAmount());
      expect(result, const Right<Failure, int>(tAmount));
    });
  });

  // ─── GetMyDayAmount ─────────────────────────────────────────────────────

  group('GetMyDayAmount', () {
    const tAmount = 5;

    test('harus memanggil repository.getMyDayAmount()', () async {
      when(mockRepository.getMyDayAmount())
          .thenAnswer((_) async => const Right(tAmount));

      final usecase = GetMyDayAmount(mockRepository);
      final result = await usecase(NoParams());

      verify(mockRepository.getMyDayAmount());
      expect(result, const Right<Failure, int>(tAmount));
    });
  });

  // ─── GetTagMenuItems ────────────────────────────────────────────────────

  group('GetTagMenuItems', () {
    test('harus memanggil repository.getTagMenuItems()', () async {
      when(mockRepository.getTagMenuItems())
          .thenAnswer((_) async => const Right(tTagMenuList));

      final usecase = GetTagMenuItems(mockRepository);
      final result = await usecase(NoParams());

      verify(mockRepository.getTagMenuItems());
      expect(result, const Right<Failure, List<TagMenuItem>>(tTagMenuList));
    });
  });

  // ─── UpdateTagsOrder ────────────────────────────────────────────────────

  group('UpdateTagsOrder', () {
    const tParams = UpdateTagsOrderParams(tags: [tTagMenuItem]);

    test('harus memanggil repository.updateTagsOrder() dengan params yang benar',
        () async {
      when(mockRepository.updateTagsOrder(tParams))
          .thenAnswer((_) async => const Right(null));

      final usecase = UpdateTagsOrder(mockRepository);
      final result = await usecase(tParams);

      verify(mockRepository.updateTagsOrder(tParams));
      expect(result.isRight(), true);
    });
  });
}
