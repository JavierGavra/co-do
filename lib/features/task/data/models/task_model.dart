import '../../../tag/domain/entities/tag.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    super.id,
    required super.title,
    super.dueDate,
    super.note,
    required super.status,
    super.tag,
  });

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      note: task.note,
      status: task.status,
      tag: task.tag,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      title: json["title"],
      dueDate: (json["due_date_time"] != null)
          ? DateTime.parse(json["due_date_time"])
          : null,
      note: json["note"],
      status: (json['status'] == 1),
      tag: json['tag_id'] != null
          ? Tag(
              id: json['tag_id'],
              title: json['tag_title'],
              backgroundHex: json['tag_background_hex'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "due_date_time": (dueDate != null) ? dueDate!.toIso8601String() : null,
      "note": note,
      "status": status ? 1 : 0,
      "tag_id": tag?.id,
    };
  }
}
