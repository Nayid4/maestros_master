import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:maestros_master/domain/models/dias.dart';

void showAddDayDialog(BuildContext context, Function addNewDay, Function setState, List<Dia> selectedDays, String selectedDay, List<String> daysOfWeek) {
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController horaFinController = TextEditingController();
  TimeOfDay? selectedHoraInicio;
  TimeOfDay? selectedHoraFin;
  String tempSelectedDay = selectedDay;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Agregar Horario"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: tempSelectedDay,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        tempSelectedDay = newValue;
                      });
                    }
                  },
                  items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedHoraInicio = picked;
                        horaInicioController.text = picked.format(context);
                      });
                    }
                  },
                  child: const Text("Seleccionar hora de inicio"),
                ),
                if (horaInicioController.text.isNotEmpty)
                  Text("Hora de inicio seleccionada: ${horaInicioController.text}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedHoraFin = picked;
                        horaFinController.text = picked.format(context);
                      });
                    }
                  },
                  child: const Text("Seleccionar hora de fin"),
                ),
                if (horaFinController.text.isNotEmpty)
                  Text("Hora de fin seleccionada: ${horaFinController.text}"),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedHoraInicio != null && selectedHoraFin != null) {
                    Dia newDay = Dia(
                      idDia: const Uuid().v4(),
                      nombreDia: tempSelectedDay,
                      horaInicio: DateTime(0, 0, 0, selectedHoraInicio!.hour, selectedHoraInicio!.minute),
                      horaFin: DateTime(0, 0, 0, selectedHoraFin!.hour, selectedHoraFin!.minute),
                    );
                    addNewDay(newDay); // Llama a la función de callback para agregar un nuevo horario
                    Navigator.of(context).pop();
                  } else {
                    // Manejar el caso en el que una o ambas horas no están seleccionadas
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          );
        },
      );
    },
  );
}
