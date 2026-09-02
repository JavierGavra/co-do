import 'package:codo/shared/domain/entities/tag.dart' as shared show Tag;

typedef BaseTag = shared.Tag;

class Tag extends BaseTag {
  final int taskAmount;

  const Tag({
    required super.id,
    required super.title,
    required super.backgroundHex,
    this.taskAmount = 0,
  });

  @override
  List<Object?> get props => [id, title, backgroundHex, taskAmount];
}
