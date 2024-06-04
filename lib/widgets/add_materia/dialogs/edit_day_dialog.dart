import 'package:flutter/material.dart';
import 'package:maestros_master/domain/models/dias.dart';

void showEditDayDialog(BuildContext context, Function setState, Dia dia, List<String> daysOfWeek) {
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController horaFinController = TextEditingController();
  TimeOfDay selectedHoraInicio = TimeOfDay.fromDateTime(dia.horaInicio);
  TimeOfDay selectedHoraFin = TimeOfDay.fromDateTime(dia.horaFin);
  String tempSelectedDay = dia.nombreDia;

  horaInicioController.text = selectedHoraInicio.format(context);
  horaFinController.text = selectedHoraFin.format(context);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Editar Horario"),
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
                      initialTime: selectedHoraInicio,
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
                      initialTime: selectedHoraFin,
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
                  setState(() {
                    dia.nombreDia = tempSelectedDay;
                    dia.horaInicio = DateTime(0, 0, 0, selectedHoraInicio.hour, selectedHoraInicio.minute);
                    dia.horaFin = DateTime(0, 0, 0, selectedHoraFin.hour, selectedHoraFin.minute);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}
