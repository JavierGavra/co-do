class Task {
  int id;
  String title;
  DateTime? dueDate;
  String? note;
  Set<Tag> tags;

  Task({
    this.id = -1,
    required this.title,
    required this.dueDate,
    this.note,
    this.tags = const {},
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data["id"],
      title: data["title"],
      dueDate: (data["due_date_time"] != null)
          ? DateTime.parse(data["due_date_time"])
          : null,
      note: data["note"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "due_date_time": (dueDate != null) ? dueDate!.toIso8601String() : null,
      "note": note,
    };
  }
}

class Tag {
  final String text;
  final String backgroundHex;
  final bool isBackgroundDark;

  const Tag({
    required this.text,
    required this.backgroundHex,
    this.isBackgroundDark = false,
  });
}
