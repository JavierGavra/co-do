import 'package:equatable/equatable.dart';

import '../../../tag/domain/entities/tag.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final DateTime? dueDate;
  final String? note;
  final bool status;
  final Tag? tag;

  const Task({
    this.id,
    required this.title,
    this.dueDate,
    this.note,
    this.status = false,
    this.tag,
  });

  @override
  List<Object?> get props => [id, title, dueDate, note, status, tag];
}
