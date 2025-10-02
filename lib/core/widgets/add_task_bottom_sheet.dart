import 'package:codo/core/widgets/due_date_field.dart';
import 'package:codo/core/widgets/due_time_field.dart';
import 'package:flutter/material.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final List<bool> showAdditional = [false, false];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: (MediaQuery.viewInsetsOf(context).bottom > 0) ? 305 : 0,
      ),
      child: Container(
        width: double.infinity,
        color: color.surfaceContainer,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
                // CloseButton(),
                SizedBox(
                  height: 32,
                  width: 32,
                  child: IconButton.filled(
                    onPressed: () => Navigator.pop(context),
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
            ),
            SizedBox(height: 16),

            // Titlw
            TextField(
              autofocus: true,
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
            ),

            // Note
            if (showAdditional[0]) _noteSection(context),

            // Due Date
            if (showAdditional[1]) _dueDateSection(),

            // Additional
            if (!showAdditional.every((element) => element == true))
              Padding(
                padding: const EdgeInsets.only(bottom: 2, top: 10),
                child: Text(
                  "Tambahan",
                  style: TextStyle(fontWeight: FontWeight.w500, height: 1.42),
                ),
              ),
            Wrap(
              spacing: 8,
              children: [
                if (showAdditional[0] == false)
                  _additionalChip(
                    context,
                    id: 0,
                    color: color.tertiary,
                    label: "Catatan",
                    icon: Icons.edit,
                  ),
                if (showAdditional[1] == false)
                  _additionalChip(
                    context,
                    id: 1,
                    color: color.error,
                    label: "Jatuh Tempo",
                    icon: Icons.calendar_month_outlined,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //============================================================================

  Widget _dueDateSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            flex: 3,
            child: DueDateField(onChanged: (value) => print(value)),
          ),
          Expanded(child: DueTimeField(onChanged: (value) => print(value))),
        ],
      ),
    );
  }

  Widget _noteSection(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: TextField(
        textInputAction: TextInputAction.newline,
        maxLines: null,
        style: TextStyle(fontSize: 13, height: 1.53),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(),
          label: Text("Catatan"),
          hint: Text(
            "Catatan...",
            style: TextStyle(
              color: color.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _additionalChip(
    BuildContext context, {
    required int id,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
    return ActionChip(
      onPressed: () => setState(() => showAdditional[id] = true),
      label: Text(label),
      side: BorderSide(color: color),
      backgroundColor: backgroundColor,
      visualDensity: VisualDensity.comfortable,
      labelStyle: TextStyle(color: color),
      avatar: Icon(icon, color: color),
    );
  }
}

void showAddTaskBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AddTaskBottomSheet();
    },
  );
}
