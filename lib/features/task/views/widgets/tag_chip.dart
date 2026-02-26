import 'package:codo/core/utils/color/color_utils.dart';
import 'package:codo/features/task/models/tag.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip(this.tag, {super.key});
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex(tag.backgroundHex),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag.title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 12,
          height: 1.33,
        ),
      ),
    );
  }
}
