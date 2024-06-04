import 'package:flutter/material.dart';
import 'package:maestros_master/domain/models/dias.dart';

Widget buildDaysList(List<Dia> selectedDays, BuildContext context, Function showEditDayDialog, Function setState) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Días de clase"),
      if (selectedDays.isNotEmpty)
        Column(
          children: selectedDays.map((day) {
            return Card(
              child: ListTile(
                title: Text(day.nombreDia),
                subtitle: Text(
                    'Inicio: ${_formatTimeOfDay(context, day.horaInicio)} - Fin: ${_formatTimeOfDay(context, day.horaFin)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showEditDayDialog(context, day);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          selectedDays.remove(day);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
    ],
  );
}

String _formatTimeOfDay(BuildContext context, DateTime dateTime) {
  final TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
  final localizations = MaterialLocalizations.of(context);
  return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
}
