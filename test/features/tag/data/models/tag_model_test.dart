import 'package:codo/features/tag/data/models/tag_model.dart';
import 'package:codo/features/tag/domain/entities/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TagModel', () {
    const tTagModel = TagModel(
      id: 1,
      title: 'Kuliah',
      backgroundHex: '#FF5733',
    );

    // ─── fromJson ──────────────────────────────────────────────────────────

    group('fromJson', () {
      test('harus mengembalikan TagModel yang valid dari Map', () {
        final json = {'id': 1, 'title': 'Kuliah', 'background_hex': '#FF5733'};

        final result = TagModel.fromJson(json);

        expect(result.id, 1);
        expect(result.title, 'Kuliah');
        expect(result.backgroundHex, '#FF5733');
      });
    });

    // ─── toJson ────────────────────────────────────────────────────────────

    group('toJson', () {
      test('harus menghasilkan Map yang valid', () {
        final result = tTagModel.toJson();

        expect(result['title'], 'Kuliah');
        expect(result['background_hex'], '#FF5733');
        // id tidak disertakan di toJson
        expect(result.containsKey('id'), false);
      });
    });

    // ─── is-a Tag ──────────────────────────────────────────────────────────

    test('TagModel adalah subtype dari Tag', () {
      expect(tTagModel, isA<Tag>());
    });

    test('dua TagModel dengan data sama harus equal', () {
      const tagModel2 = TagModel(
        id: 1,
        title: 'Kuliah',
        backgroundHex: '#FF5733',
      );

      expect(tTagModel, tagModel2);
    });
  });
}
