import 'package:equatable/equatable.dart';

class TagMenuItem extends Equatable {
  final int id;
  final String title;
  final String backgroundHex;
  final int taskAmount;

  const TagMenuItem({
    required this.id,
    required this.title,
    required this.backgroundHex,
    required this.taskAmount,
  });

  @override
  List<Object> get props => [id, title, backgroundHex, taskAmount];
}
