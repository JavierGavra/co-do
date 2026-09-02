import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../core/widgets/dialog/color_picker_dialog.dart';
import '../../../../injection.dart';
import '../bloc/create_tag/create_tag_bloc.dart';

Future<bool?> showCreateTagsDialog({required BuildContext context}) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => _CreateTagsDialog(),
  );
}

class _CreateTagsDialog extends StatefulWidget {
  const _CreateTagsDialog();

  @override
  State<_CreateTagsDialog> createState() => _CreateTagsDialogState();
}

class _CreateTagsDialogState extends State<_CreateTagsDialog> {
  final _bloc = sl<CreateTagBloc>();
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _tagColor = ValueNotifier<Color>(Colors.red);

  void submit() {
    if (_formKey.currentState!.validate()) {
      _bloc.add(
        CreateTagSubmitted(
          title: _textController.text,
          backgroundHex: _tagColor.value.toHexString(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _tagColor.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocConsumer<CreateTagBloc, CreateTagState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.status == CreateTagStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == CreateTagStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "Terjadi kesalahan")),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !state.isLoading,
          child: AlertDialog(
            title: Text("Buat Tag Baru"),
            titleTextStyle: TextStyle(fontSize: 16, color: color.onSurface),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [_buildTextField(), _buildColorField(color)],
                  ),
                ],
              ),
            ),
            actions: [FilledButton(onPressed: submit, child: Text("Buat"))],
          ),
        );
      },
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: TextFormField(
        autofocus: true,
        maxLength: 30,
        controller: _textController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            value == null || value.isEmpty ? "Tidak boleh kosong" : null,
        decoration: InputDecoration(
          hintText: "Nama tag",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildColorField(ColorScheme color) {
    return ValueListenableBuilder(
      valueListenable: _tagColor,
      builder: (_, value, __) {
        return InkWell(
          onTap: () async {
            _tagColor.value = await showColorPickerDialog(
              context: context,
              initialColor: value,
            );
          },
          child: Ink(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: value,
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: color.onSurface),
            ),
            child: Icon(Icons.color_lens, color: Colors.white),
          ),
        );
      },
    );
  }
}
