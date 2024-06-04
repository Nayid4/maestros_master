import 'package:flutter/material.dart';

Widget buildTimePicker({
  required BuildContext context,
  required TextEditingController controller,
  required String labelText,
  required Function(TimeOfDay) onTimeSelected,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(labelText),
      ElevatedButton(
        onPressed: () {
          _showTimePicker(context, controller, onTimeSelected);
        },
        child: const Text("Seleccionar hora"),
      ),
      if (controller.text.isNotEmpty)
        Text("Hora seleccionada: ${controller.text}"),
    ],
  );
}

void _showTimePicker(BuildContext context, TextEditingController controller, Function(TimeOfDay) onTimeSelected) {
  showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  ).then((value) {
    if (value != null) {
      controller.text = value.format(context);
      onTimeSelected(value);
    }
  });
}
