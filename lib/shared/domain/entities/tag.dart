import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int id;
  final String title;
  final String backgroundHex;

  const Tag({
    required this.id,
    required this.title,
    required this.backgroundHex,
  });

  @override
  List<Object?> get props => [id, title, backgroundHex];
}
