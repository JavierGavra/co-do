import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dialog/loading_dialog.dart';
import '../../../../injection.dart';
import '../bloc/rename_tag/rename_tag_bloc.dart';

Future<String?> showRenameTagDialog({
  required BuildContext context,
  required int tagId,
  required String currentTitle,
}) async {
  return showDialog(
    context: context,
    builder: (context) =>
        _RenameTagDialog(tagId: tagId, initialTitle: currentTitle),
  );
}

class _RenameTagDialog extends StatefulWidget {
  const _RenameTagDialog({required this.tagId, required this.initialTitle});

  final int tagId;
  final String initialTitle;

  @override
  State<_RenameTagDialog> createState() => _RenameTagDialogState();
}

class _RenameTagDialogState extends State<_RenameTagDialog> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _bloc = sl<RenameTagBloc>();

  void _listener(BuildContext context, RenameTagState state) {
    if (state.isSuccess || state.isFailure) Navigator.pop(context);

    if (state.isSuccess) {
      Navigator.of(context).pop(_titleController.text);
    } else if (state.isFailure) {
      Navigator.of(context).pop(null);
    }
  }

  void _onYes() {
    if (_formKey.currentState!.validate()) {
      showLoadingDialog(context: context);
      _bloc.add(
        RenameTagRequested(
          tagId: widget.tagId,
          newTitle: _titleController.text,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocListener<RenameTagBloc, RenameTagState>(
      bloc: _bloc,
      listener: _listener,
      child: AlertDialog(
        title: const Text('Ganti Nama Kategori'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            key: ValueKey("title"),
            autofocus: true,
            controller: _titleController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hint: Text(
                "Judul",
                style: TextStyle(
                  color: color.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
              border: OutlineInputBorder(),
              visualDensity: VisualDensity.comfortable,
            ),
            validator: (value) {
              return (value == null || value.isEmpty) ? "Wajib di isi" : null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text("Tidak", style: TextStyle(color: color.error)),
          ),
          FilledButton(onPressed: _onYes, child: const Text("Ya")),
        ],
      ),
    );
  }
}
