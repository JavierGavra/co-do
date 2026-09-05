import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dialog/loading_dialog.dart';
import '../../../../injection.dart';
import '../bloc/delete_tag/delete_tag_bloc.dart';

Future<bool?> showDeleteTagDialog({
  required BuildContext context,
  required int tagId,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => _DeleteTagDialog(tagId: tagId),
  );
}

class _DeleteTagDialog extends StatefulWidget {
  final int tagId;

  const _DeleteTagDialog({required this.tagId});

  @override
  State<_DeleteTagDialog> createState() => _DeleteTagDialogState();
}

class _DeleteTagDialogState extends State<_DeleteTagDialog> {
  final bloc = sl<DeleteTagBloc>();
  bool isDeleteWithTasks = false;

  void _listener(BuildContext context, DeleteTagState state) {
    if (state.isSuccess || state.isFailure) Navigator.pop(context);

    if (state.isSuccess) {
      Navigator.of(context).pop(true);
    } else if (state.isFailure) {
      Navigator.of(context).pop(false);
    }
  }

  void _onYes() async {
    showLoadingDialog(context: context);
    if (isDeleteWithTasks) {
      bloc.add(DeleteTagWithTasksRequested(widget.tagId));
    } else {
      bloc.add(DeleteTagOnlyRequested(widget.tagId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocListener<DeleteTagBloc, DeleteTagState>(
      bloc: bloc,
      listener: _listener,
      child: AlertDialog(
        title: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hapus Kategori",
              style: TextStyle(
                fontSize: 16,
                color: color.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Yakin ingin menghapus kategori ini?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 12, bottom: 16, top: 10),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isDeleteWithTasks = !isDeleteWithTasks;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: isDeleteWithTasks,
                      onChanged: (value) {
                        setState(() {
                          isDeleteWithTasks = value!;
                        });
                      },
                    ),
                    const Text("Beserta semua tugas"),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () => _onYes(),
            child: Text("Ya", style: TextStyle(color: color.error)),
          ),
        ],
      ),
    );
  }
}
