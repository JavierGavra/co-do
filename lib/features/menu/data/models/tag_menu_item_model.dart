import '../../domain/entities/tag_menu_item.dart';

class TagMenuItemModel extends TagMenuItem {
  const TagMenuItemModel({
    required super.id,
    required super.title,
    required super.backgroundHex,
    required super.taskAmount,
  });

  factory TagMenuItemModel.fromMap(Map<String, dynamic> map) {
    return TagMenuItemModel(
      id: map['id'] as int,
      title: map['title'] as String,
      backgroundHex: map['background_hex'] as String,
      taskAmount: map['task_amount'] ?? 0,
    );
  }
}
