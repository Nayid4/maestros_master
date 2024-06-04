import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/dias.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/pages/maters/add_materia/add_materia.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/widgets/add_materia/widgets/text_field.dart';
import 'package:maestros_master/widgets/add_materia/widgets/icon_button_add_day.dart';
import 'package:maestros_master/widgets/add_materia/widgets/days_list.dart';
import 'package:maestros_master/widgets/add_materia/dialogs/add_day_dialog.dart';
import 'package:maestros_master/widgets/add_materia/dialogs/edit_day_dialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddMateriaState extends State<AddMateria> {
  final TextEditingController nombreController = TextEditingController();
  String selectedDay = 'Lunes';
  List<Dia> selectedDays = [];
  final MateriasController materiasController = Get.find();

  @override
  void initState() {
    super.initState();
    nombreController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    const Color miColor = Color.fromRGBO(0, 191, 99, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Materia", style: TextStyle(color: Colors.white)),
        backgroundColor: miColor,
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso a blanco
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            buildTextField(
              controller: nombreController,
              labelText: "Nombre de la materia",
            ),
            const SizedBox(height: 20),
            buildIconButtonAddDay(context, (context) => showAddDayDialog(context, setState, selectedDays, selectedDay, [
              'Lunes',
              'Martes',
              'Miércoles',
              'Jueves',
              'Viernes',
              'Sábado'
            ])),
            const SizedBox(height: 20),
            buildDaysList(selectedDays, context, (context, dia) => showEditDayDialog(context, setState, dia, [
              'Lunes',
              'Martes',
              'Miércoles',
              'Jueves',
              'Viernes',
              'Sábado'
            ]), setState),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 191, 99, 1), // Cambia el color del botón
          ),
          onPressed: () {
            _addMateria(
              nombreController.text,
              selectedDays,
              materiasController,
              context,
            );
          },
          child: const Text("Guardar Cambios", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
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
      estudiantes: [],
    );

    await materiasController.addMateria(nuevaMateria);
    Get.back(result: true);
  }
}
