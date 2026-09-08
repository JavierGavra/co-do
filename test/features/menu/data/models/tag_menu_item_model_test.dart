import 'package:codo/features/menu/data/models/tag_menu_item_model.dart';
import 'package:codo/features/menu/domain/entities/tag_menu_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TagMenuItemModel', () {
    const tModel = TagMenuItemModel(
      id: 1,
      title: 'Kuliah',
      backgroundHex: '#FF5733',
      taskAmount: 3,
    );

    // ─── fromMap ───────────────────────────────────────────────────────────

    group('fromMap', () {
      test('harus mengembalikan TagMenuItemModel yang valid dari Map', () {
        final map = {
          'id': 1,
          'title': 'Kuliah',
          'background_hex': '#FF5733',
          'task_amount': 3,
        };

        final result = TagMenuItemModel.fromMap(map);

        expect(result.id, 1);
        expect(result.title, 'Kuliah');
        expect(result.backgroundHex, '#FF5733');
        expect(result.taskAmount, 3);
      });

      test('task_amount harus default 0 ketika null', () {
        final map = {
          'id': 2,
          'title': 'Hobi',
          'background_hex': '#0000FF',
          'task_amount': null,
        };

        final result = TagMenuItemModel.fromMap(map);

        expect(result.taskAmount, 0);
      });
    });

    // ─── is-a TagMenuItem ──────────────────────────────────────────────────

    test('TagMenuItemModel adalah subtype dari TagMenuItem', () {
      expect(tModel, isA<TagMenuItem>());
    });

    test('dua model dengan data yang sama harus equal', () {
      const tModel2 = TagMenuItemModel(
        id: 1,
        title: 'Kuliah',
        backgroundHex: '#FF5733',
        taskAmount: 3,
      );

      expect(tModel, tModel2);
    });
  });
}
