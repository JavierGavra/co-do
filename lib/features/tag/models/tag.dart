class Tag {
  final int id;
  final String title;
  final String backgroundHex;

  const Tag({
    required this.id,
    required this.title,
    required this.backgroundHex,
  });

  factory Tag.fromMap(Map<String, dynamic> data) {
    return Tag(
      id: data['id'],
      title: data['title'],
      backgroundHex: data['background_hex'],
    );
  }
}
