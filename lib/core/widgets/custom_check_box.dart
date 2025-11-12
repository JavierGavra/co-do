import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({super.key, required this.onTap, required this.value});

  final VoidCallback onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      customBorder: CircleBorder(),
      splashColor: value ? color.surfaceContainer : color.primaryContainer,
      child: Ink(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? color.secondaryContainer : null,
          border: value
              ? null
              : Border.all(
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                  color: color.outline,
                ),
        ),
        child: value
            ? Icon(Icons.check_rounded, color: color.onSecondaryContainer)
            : null,
      ),
    );
  }
}
