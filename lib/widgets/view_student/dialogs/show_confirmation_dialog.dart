import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';

void showConfirmationDialog(BuildContext context, MateriasController controlm, Materia selectedMateria, int index) {
  final Estudiante estudiante = controlm.getEstudiantesFromMateria(selectedMateria.idMateria)[index];
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text("¿Desea eliminar este estudiante?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              await controlm.removeEstudianteFromMateria(selectedMateria.idMateria, estudiante.idEstudiante);
              Navigator.of(context).pop();
            },
            child: const Text("Confirmar"),
          ),
        ],
      );
    },
  );
}
