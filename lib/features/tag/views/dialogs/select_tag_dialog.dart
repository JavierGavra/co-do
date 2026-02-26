import 'package:codo/core/utils/color/color_utils.dart';
import 'package:codo/features/tag/cubit/tag_cubit.dart';
import 'package:codo/features/tag/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<Tag?> showSelectTagDialog({required BuildContext context}) async {
  return await showDialog<Tag>(
    context: context,
    builder: (context) => BlocProvider(
      create: (context) => TagCubit()..initDialog(),
      child: _SelectTagDialog(),
    ),
  );
}

class _SelectTagDialog extends StatelessWidget {
  const _SelectTagDialog();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text("Pilih Kategori"),
      titleTextStyle: TextStyle(fontSize: 16, color: color.onSurface),
      content: BlocSelector<TagCubit, TagState, List<Tag>>(
        selector: (state) => state.tags,
        builder: (context, state) {
          return Wrap(
            spacing: 8,
            children: List.generate(state.length, (index) {
              return _buildChip(context, state[index]);
            }),
          );
        },
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, Tag tag) {
    return ActionChip(
      onPressed: () => Navigator.pop(context, tag),
      side: BorderSide(color: ColorUtils.fromHex(tag.backgroundHex)),
      visualDensity: VisualDensity.compact,
      label: Text(tag.title),
      labelStyle: TextStyle(color: ColorUtils.fromHex(tag.backgroundHex)),
    );
  }
}
