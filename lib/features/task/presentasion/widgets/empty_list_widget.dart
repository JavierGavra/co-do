import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final ColorScheme? colorScheme;

  const EmptyListWidget({super.key, this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;
    final color = colorScheme ?? Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.fromLTRB(42, 64, 42, 24),
      padding: EdgeInsets.symmetric(vertical: 84),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text('🗂️', style: TextStyle(fontSize: 72)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              spacing: 8,
              children: [
                Text(
                  'Belum Ada Tugas',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? color.onSecondaryContainer
                        : color.secondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Tambahkan tugas baru dengan menekan tombol +',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? color.onSecondaryContainer
                        : color.secondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
