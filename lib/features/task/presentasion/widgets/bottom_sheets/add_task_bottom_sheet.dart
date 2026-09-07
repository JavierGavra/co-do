import 'package:flutter/material.dart';

import '../../../../../core/utils/color/color_utils.dart';
import '../../../../../shared/domain/entities/tag.dart';
import '../../../../tag/presentasion/dialogs/select_tag_dialog.dart';
import '../../../domain/entities/task.dart';
import '../chip/task_additional_chip.dart';
import '../input/task_due_field.dart';
import '../input/task_note_field.dart';
import '../input/title_field.dart';

Future<Task?> showAddTaskBottomSheet(BuildContext context, {Tag? initialTag}) {
  return showModalBottomSheet<Task>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AddTaskBottomSheet(initialTag: initialTag);
    },
  );
}

class AddTaskBottomSheet extends StatefulWidget {
  final Tag? initialTag;

  const AddTaskBottomSheet({super.key, this.initialTag});

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

  void _onAdditionalFieldPressed(AdditionalField fieldType) {
    if (fieldType == AdditionalField.dueDate) {
      _dueDate = DateTime.now().copyWith(hour: 23, minute: 59, second: 0);
    }
    setState(() => _visibleFields.add(fieldType));
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialTag != null) {
      _tag.value = widget.initialTag;
      _visibleFields.add(AdditionalField.tag);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tag.dispose();
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
              TitleField(
                key: ValueKey("title"),
                titleController: _titleController,
              ),

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

  Widget _dueDateSection() {
    return Padding(
      key: ValueKey('dueDate'),
      padding: EdgeInsets.only(top: 10),
      child: TaskDueField(
        initialDate: _dueDate!,
        onDueChanged: (value) {
          _dueDate = _dueDate!.copyWith(
            year: value.year,
            month: value.month,
            day: value.day,
            hour: value.hour,
            minute: value.minute,
            second: 0,
          );
        },
      ),
    );
  }

  Widget _noteSection(BuildContext context) {
    return Padding(
      key: ValueKey('note'),
      padding: EdgeInsets.only(top: 15),
      child: TaskNoteField(onChanged: (value) => _note = value),
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
                        _tag.value = Tag(
                          id: data.id,
                          title: data.title,
                          backgroundHex: data.backgroundHex,
                        );
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
          TaskAdditionalChip(
            label: "Catatan",
            icon: Icons.edit,
            color: color.tertiary,
            fieldType: AdditionalField.note,
            onPressed: _onAdditionalFieldPressed,
          ),
        if (!_visibleFields.contains(AdditionalField.dueDate))
          TaskAdditionalChip(
            label: "Jatuh Tempo",
            icon: Icons.calendar_month_outlined,
            color: color.error,
            fieldType: AdditionalField.dueDate,
            onPressed: _onAdditionalFieldPressed,
          ),
        if (!_visibleFields.contains(AdditionalField.tag))
          TaskAdditionalChip(
            label: "Kategori",
            icon: Icons.category_outlined,
            color: color.secondary,
            fieldType: AdditionalField.tag,
            onPressed: _onAdditionalFieldPressed,
          ),
      ],
    );
  }
}
