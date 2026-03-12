import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int? id;
  final String title;
  final String backgroundHex;
  final int taskAmount;

  const Tag({
    this.id,
    required this.title,
    required this.backgroundHex,
    this.taskAmount = 0,
  });

  @override
  List<Object?> get props => [id, title, backgroundHex, taskAmount];
}
