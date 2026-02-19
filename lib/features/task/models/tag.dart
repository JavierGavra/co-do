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
