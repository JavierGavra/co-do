class Tag {
  final int? id;
  final int amount;
  final String title;
  final String backgroundHex;

  const Tag({
    this.id,
    required this.title,
    required this.backgroundHex,
    this.amount = 0,
  });

  factory Tag.fromMap(Map<String, dynamic> data) {
    return Tag(
      id: data['id'],
      title: data['title'],
      backgroundHex: data['background_hex'],
    );
  }
}
