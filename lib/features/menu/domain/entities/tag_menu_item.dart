import 'package:codo/shared/domain/entities/tag.dart';

class TagMenuItem extends Tag {
  final int taskAmount;

  const TagMenuItem({
    required super.id,
    required super.title,
    required super.backgroundHex,
    required this.taskAmount,
  });

  @override
  List<Object> get props => [id, title, backgroundHex, taskAmount];
}
