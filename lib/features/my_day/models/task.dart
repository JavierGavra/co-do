class Task {
  String title;
  DateTime dueDate;
  String? note;
  Set<Tag> tags;

  Task({
    required this.title,
    required this.dueDate,
    this.note,
    this.tags = const {},
  });

  static List<Task> dummy() {
    return [
      Task(
        title: "Proposisi Soal 1 sampai 9",
        dueDate: DateTime(2025, 3, 7, 23, 59),
        note:
            "Dikerjakan di kertas folio dengan Tabel.\nDikumpulkan di Kulino.",
        tags: {Tag(text: "Logika Informatika", backgroundHex: "86DDFD")},
      ),

      Task(
        title: "Membuat Database Toko Online",
        dueDate: DateTime(2025, 3, 13, 16, 0),
        tags: {
          Tag(
            text: "Basis Data",
            backgroundHex: "6456D1",
            isBackgroundDark: true,
          ),
        },
      ),
      Task(
        title: "Buat website statis",
        dueDate: DateTime(2025, 3, 15, 23, 59),
        note: "Tidak boleh menggunakan framework",
        tags: {Tag(text: "Pemrograman Web", backgroundHex: "D7DDE0")},
      ),
      Task(
        title: "Presentasi",
        dueDate: DateTime(2025, 3, 16, 6, 0),
        tags: {Tag(text: "Sistem Operasi", backgroundHex: "F6CF82")},
      ),
    ];
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
