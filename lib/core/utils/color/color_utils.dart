import 'package:flutter/material.dart';

class ColorUtils {
  static Color fromHex(String hex) {
    return Color(int.parse('0xFF$hex'));
  }
}
