import '../../domain/entities/tag.dart';

class TagModel extends Tag {
  const TagModel({
    required super.id,
    required super.title,
    required super.backgroundHex,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      title: json['title'],
      backgroundHex: json['background_hex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'background_hex': backgroundHex};
  }
}
