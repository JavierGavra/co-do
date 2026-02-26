import 'package:codo/core/utils/color/color_utils.dart';
import 'package:codo/features/tag/views/dialogs/select_tag_dialog.dart';
import 'package:codo/features/task/models/tag.dart';
import 'package:codo/features/task/views/widgets/due_date_field.dart';
import 'package:codo/features/task/views/widgets/due_time_field.dart';
import 'package:codo/features/task/models/task.dart';
import 'package:flutter/material.dart';

enum AdditionalField { note, dueDate, tag }

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  final Set<AdditionalField> _visibleFields = {};
  DateTime? _dueDate;
  String _note = "";
  final _tag = ValueNotifier<Tag?>(null);

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _titleController.text,
        dueDate: _dueDate,
        note: (_note.isEmpty) ? null : _note,
        tag: _tag.value,
      );
      Navigator.pop(context, task);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: (MediaQuery.viewInsetsOf(context).bottom > 0) ? 325 : 0,
      ),
      child: Container(
        width: double.infinity,
        color: color.surfaceContainer,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              SizedBox(height: 16),

              // Titlw
              _titleField(color),

              // Note
              if (_visibleFields.contains(AdditionalField.note))
                _noteSection(context),

              // Due Date
              if (_visibleFields.contains(AdditionalField.dueDate))
                _dueDateSection(),

              // Tag
              if (_visibleFields.contains(AdditionalField.tag))
                _tagSection(color),

              // Additional
              if (_visibleFields.length < AdditionalField.values.length) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, top: 10),
                  child: Text(
                    "Tambahan",
                    style: TextStyle(fontWeight: FontWeight.w500, height: 1.42),
                  ),
                ),
                _additionalSection(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  //============================================================================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Tambahkan Tugas",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        SizedBox(
          height: 32,
          width: 32,
          child: IconButton.filled(
            onPressed: _submit,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_upward_rounded, size: 20),
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleField(ColorScheme color) {
    return TextFormField(
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
    );
  }

  Widget _dueDateSection() {
    return Padding(
      key: ValueKey('dueDate'),
      padding: EdgeInsets.only(top: 10),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            flex: 3,
            child: DueDateField(
              initialDate: _dueDate!,
              onChanged: (value) => _dueDate = _dueDate!.copyWith(
                year: value.year,
                month: value.month,
                day: value.day,
              ),
            ),
          ),
          Expanded(
            child: DueTimeField(
              initialTime: TimeOfDay.fromDateTime(_dueDate!),
              onChanged: (value) => _dueDate = _dueDate!.copyWith(
                hour: value.hour,
                minute: value.minute,
                second: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteSection(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      key: ValueKey('note'),
      padding: EdgeInsets.only(top: 15),
      child: TextField(
        onChanged: (value) => _note = value,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        style: const TextStyle(fontSize: 13, height: 1.53),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(),
          labelText: "Catatan",
          hintText: "Catatan...",
          hintStyle: TextStyle(
            color: color.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _tagSection(ColorScheme color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 10),
          child: Text(
            "Kategori",
            style: TextStyle(fontWeight: FontWeight.w500, height: 1.42),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _tag,
          builder: (context, value, child) {
            return Wrap(
              spacing: 8,
              children: [
                if (value != null)
                  Chip(
                    onDeleted: () => _tag.value = null,
                    backgroundColor: ColorUtils.fromHex(value.backgroundHex),
                    side: BorderSide(
                      color: ColorUtils.fromHex(value.backgroundHex),
                    ),
                    visualDensity: VisualDensity.compact,
                    deleteIcon: Icon(Icons.close, color: Colors.white),
                    label: Text(value.title),
                    labelStyle: TextStyle(color: Colors.white),
                  ),

                if (value == null)
                  ActionChip(
                    onPressed: () async {
                      final data = await showSelectTagDialog(context: context);
                      if (data != null) {
                        setState(() {
                          _tag.value = Tag(
                            id: data.id,
                            title: data.title,
                            backgroundHex: data.backgroundHex,
                          );
                        });
                      }
                    },
                    visualDensity: VisualDensity.compact,
                    label: Icon(Icons.add_rounded, size: 20),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _additionalSection(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      children: [
        if (!_visibleFields.contains(AdditionalField.note))
          _additionalChip(
            label: "Catatan",
            icon: Icons.edit,
            color: color.tertiary,
            fieldType: AdditionalField.note,
          ),
        if (!_visibleFields.contains(AdditionalField.dueDate))
          _additionalChip(
            label: "Jatuh Tempo",
            icon: Icons.calendar_month_outlined,
            color: color.error,
            fieldType: AdditionalField.dueDate,
          ),
        if (!_visibleFields.contains(AdditionalField.tag))
          _additionalChip(
            label: "Kategori",
            icon: Icons.category_outlined,
            color: color.secondary,
            fieldType: AdditionalField.tag,
          ),
      ],
    );
  }

  Widget _additionalChip({
    required AdditionalField fieldType,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
    return ActionChip(
      onPressed: () {
        if (fieldType == AdditionalField.dueDate) {
          _dueDate = DateTime.now().copyWith(hour: 23, minute: 59, second: 0);
        }
        setState(() => _visibleFields.add(fieldType));
      },
      label: Text(label),
      side: BorderSide(color: color),
      backgroundColor: backgroundColor,
      avatar: Icon(icon, color: color),
      labelStyle: TextStyle(color: color),
      visualDensity: VisualDensity.comfortable,
    );
  }
}

Future<Task?> showAddTaskBottomSheet(BuildContext context) {
  return showModalBottomSheet<Task>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AddTaskBottomSheet();
    },
  );
}
