import 'package:codo/features/my_day/models/task.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip(this.tag, {super.key});
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Color(int.parse("0xff${tag.backgroundHex}")),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag.text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: tag.isBackgroundDark ? Colors.white : Colors.black,
          fontSize: 12,
          height: 1.33,
        ),
      ),
    );
  }
}
