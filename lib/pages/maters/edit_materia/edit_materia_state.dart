import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/dias.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/pages/maters/edit_materia/edit_materia.dart';
import 'package:maestros_master/widgets/edit_materia/widgets/text_field.dart';
import 'package:maestros_master/widgets/edit_materia/widgets/icon_button_add_day.dart';
import 'package:maestros_master/widgets/edit_materia/widgets/days_list.dart';
import 'package:maestros_master/widgets/edit_materia/dialogs/add_day_dialog.dart';
import 'package:maestros_master/widgets/edit_materia/dialogs/edit_day_dialog.dart';

class EditMateriaState extends State<EditMateria> {
  final TextEditingController nombreController = TextEditingController();
  String selectedDay = 'Lunes';
  List<Dia> selectedDays = [];
  final MateriasController materiasController = Get.find();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.materia.nombre;
    selectedDays = List.from(widget.materia.dias);
  }

  @override
  Widget build(BuildContext context) {
    const Color miColor = Color.fromRGBO(0, 191, 99, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Materia", style: TextStyle(color: Colors.white)),
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
            _editMateria(
              widget.materia.idMateria,
              nombreController.text,
              selectedDays,
              widget.materia.estudiantes,
              materiasController,
              context,
            );
          },
          child: const Text("Guardar Cambios", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _editMateria(
      String idMateria,
      String nombre,
      List<Dia> dias,
      List<Estudiante> estudiantes,
      MateriasController materiasController,
      BuildContext context) async {
    final Materia materiaEditada = Materia(
      idMateria: idMateria,
      nombre: nombre,
      idUsuario: widget.materia.idUsuario,
      dias: dias,
      estudiantes: estudiantes,
    );

    await materiasController.updateMateria(materiaEditada);
    Get.back(result: true);
  }
}
