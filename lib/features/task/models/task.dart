import 'package:codo/features/task/models/tag.dart';

class Task {
  int id;
  String title;
  DateTime? dueDate;
  String? note;
  bool status;
  Tag? tag;

  Task({
    this.id = -1,
    required this.title,
    required this.dueDate,
    this.note,
    this.tag,
    this.status = false,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data["id"],
      title: data["title"],
      dueDate: (data["due_date_time"] != null)
          ? DateTime.parse(data["due_date_time"])
          : null,
      note: data["note"],
      status: (data['status'] == 1),
      tag: data['tag_id'] != null
          ? Tag(
              id: data['tag_id'],
              title: data['tag_title'],
              backgroundHex: data['tag_background_hex'],
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "due_date_time": (dueDate != null) ? dueDate!.toIso8601String() : null,
      "note": note,
      "status": status,
      "tag_id": tag?.id,
    };
  }
}
