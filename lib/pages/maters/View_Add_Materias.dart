import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/dias.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddMaterias extends StatefulWidget {
  const AddMaterias({Key? key}) : super(key: key);

  @override
  _AddMateriasState createState() => _AddMateriasState();
}

class _AddMateriasState extends State<AddMaterias> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();
  final TextEditingController horaFinController = TextEditingController();
  String selectedDay = 'Lunes';
  final List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];
  List<Dia> selectedDays = [];
  final MateriasController materiasController = Get.find();
  final _horaInicioTime = TimeOfDay(hour: 0, minute: 0);
  final _horaFinTime = TimeOfDay(hour: 0, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Materia"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              controller: nombreController,
              labelText: "Nombre de la materia",
            ),
            const SizedBox(height: 20),
            _buildIconButtonAddDay(),
            const SizedBox(height: 20),
            _buildDaysList(),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addMateria(
                  nombreController.text,
                  selectedDays,
                  materiasController,
                  context,
                );
              },
              child: const Text("Agregar Materia"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildIconButtonAddDay() {
    return IconButton(
      onPressed: () {
        _showAddDayDialog(context);
      },
      icon: const Icon(Icons.add_circle_outline),
    );
  }

  Widget _buildDaysList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Días de clase"),
        if (selectedDays.isNotEmpty)
          Wrap(
            spacing: 8.0,
            children: selectedDays.map((day) {
              return Chip(
                label: Text(day.nombreDia),
                onDeleted: () {
                  setState(() {
                    selectedDays.remove(day);
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildDropDownButton() {
    return DropdownButton<String>(
      value: selectedDay,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedDay = newValue;
          });
        }
      },
      items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTimePicker(
      {required BuildContext context,
      required TextEditingController controller,
      required String labelText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        ElevatedButton(
          onPressed: () {
            _showTimePicker(context, controller);
          },
          child: const Text("Seleccionar hora"),
        ),
        if (controller.text.isNotEmpty)
          Text("Hora seleccionada: ${controller.text}"),
      ],
    );
  }

  void _showTimePicker(
      BuildContext context,
      TextEditingController controller) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        controller.text = value.format(context);
      }
    });
  }

  void _addMateria(
      String nombre,
      List<Dia> dias,
      MateriasController materiasController,
      BuildContext context) async {
    final Materia nuevaMateria = Materia(
      idMateria: const Uuid().v4(),
      nombre: nombre,
      idUsuario: Provider.of<LoginProvider>(context, listen: false)
              .currentUser?.uid ?? '',
      dias: dias,
    );
    print('Mundo');
    print(dias[0].nombreDia);
    print(dias[0].idDia);
    print(dias[0].horaInicio);
    print(dias[0].horaFin);
    await materiasController.addMateria(nuevaMateria);
    print('Hola');
    Get.back(result: true);
  }

  void _showAddDayDialog(BuildContext context) {
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController horaFinController = TextEditingController();

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
                _buildDropDownButton(),
                const SizedBox(height: 20),
                _buildTimePicker(
                  context: context,
                  controller: horaInicioController,
                  labelText: "Hora de inicio",
                ),
                const SizedBox(height: 20),
                _buildTimePicker(
                  context: context,
                  controller: horaFinController,
                  labelText: "Hora de fin",
                ),
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
                    // Crear un nuevo objeto Dia con la información seleccionada
                    Dia newDay = Dia(
                      idDia: const Uuid().v4(),
                      nombreDia: selectedDay,
                      horaInicio: TimeOfDay(
                        hour: int.parse(horaInicioController.text.split(":")[0]),
                        minute: int.parse(horaInicioController.text.split(":")[1]),
                      ),
                      horaFin: TimeOfDay(
                        hour: int.parse(horaFinController.text.split(":")[0]),
                        minute: int.parse(horaFinController.text.split(":")[1]),
                      ),
                    );
                    // Agregar el nuevo objeto Dia a la lista de días de clase
                    selectedDays.add(newDay);
                  });
                  Navigator.of(context).pop();
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

}
