import 'package:codo/features/task/data/models/task_model.dart';
import 'package:codo/features/task/domain/entities/task.dart';
import 'package:codo/shared/domain/entities/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskModel', () {
    const tTag = Tag(id: 1, title: 'Kuliah', backgroundHex: '#FF0000');

    const tTaskModel = TaskModel(
      id: 1,
      title: 'Belajar Flutter',
      dueDate: null,
      note: 'Catatan',
      status: false,
      tag: tTag,
    );

    // ─── fromJson ──────────────────────────────────────────────────────────

    group('fromJson', () {
      test('harus mengembalikan TaskModel yang valid dari JSON dengan tag', () {
        final json = {
          'id': 1,
          'title': 'Belajar Flutter',
          'due_date_time': null,
          'note': 'Catatan',
          'status': 0,
          'tag_id': 1,
          'tag_title': 'Kuliah',
          'tag_background_hex': '#FF0000',
        };

        final result = TaskModel.fromJson(json);

        expect(result.id, 1);
        expect(result.title, 'Belajar Flutter');
        expect(result.dueDate, isNull);
        expect(result.note, 'Catatan');
        expect(result.status, false);
        expect(result.tag, isNotNull);
        expect(result.tag!.id, 1);
        expect(result.tag!.title, 'Kuliah');
      });

      test('harus mengembalikan TaskModel tanpa tag ketika tag_id null', () {
        final json = {
          'id': 2,
          'title': 'Tugas tanpa tag',
          'due_date_time': null,
          'note': null,
          'status': 0,
          'tag_id': null,
          'tag_title': null,
          'tag_background_hex': null,
        };

        final result = TaskModel.fromJson(json);

        expect(result.id, 2);
        expect(result.tag, isNull);
      });

      test('harus parse due_date_time dengan benar', () {
        final dateStr = '2026-09-07T10:00:00.000';
        final json = {
          'id': 3,
          'title': 'Tugas dengan tanggal',
          'due_date_time': dateStr,
          'note': null,
          'status': 1,
          'tag_id': null,
        };

        final result = TaskModel.fromJson(json);

        expect(result.dueDate, DateTime.parse(dateStr));
        expect(result.status, true);
      });
    });

    // ─── toJson ────────────────────────────────────────────────────────────

    group('toJson', () {
      test('harus menghasilkan Map yang valid', () {
        final taskWithDate = TaskModel(
          id: 1,
          title: 'Belajar Flutter',
          dueDate: DateTime(2026, 9, 7, 10),
          note: 'Catatan',
          status: false,
          tag: tTag,
        );

        final result = taskWithDate.toJson();

        expect(result['title'], 'Belajar Flutter');
        expect(result['due_date_time'], isNotNull);
        expect(result['note'], 'Catatan');
        expect(result['status'], 0);
        expect(result['tag_id'], 1);
      });

      test('due_date_time harus null ketika dueDate tidak diisi', () {
        const taskNoDate = TaskModel(
          id: 1,
          title: 'Tanpa Tanggal',
          status: false,
        );

        final result = taskNoDate.toJson();

        expect(result['due_date_time'], isNull);
        expect(result['tag_id'], isNull);
      });

      test('status true harus dikonversi menjadi 1', () {
        const task = TaskModel(id: 1, title: 'Done', status: true);

        final result = task.toJson();

        expect(result['status'], 1);
      });
    });

    // ─── fromEntity ────────────────────────────────────────────────────────

    group('fromEntity', () {
      test('harus membuat TaskModel dari Task entity', () {
        const task = Task(
          id: 10,
          title: 'Entity Task',
          note: 'Note dari entity',
          status: true,
          tag: tTag,
        );

        final result = TaskModel.fromEntity(task);

        expect(result.id, task.id);
        expect(result.title, task.title);
        expect(result.note, task.note);
        expect(result.status, task.status);
        expect(result.tag, task.tag);
      });
    });

    test('TaskModel adalah subtype dari Task', () {
      expect(tTaskModel, isA<Task>());
    });
  });
}
