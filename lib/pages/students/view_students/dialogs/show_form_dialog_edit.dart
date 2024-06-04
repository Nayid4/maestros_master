import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';

void showFormDialogEdit(BuildContext context, MateriasController controlm, Materia selectedMateria, int index) {
  final TextEditingController textNombres = TextEditingController();
  final TextEditingController textApellidos = TextEditingController();
  final Estudiante estudiante = controlm.getEstudiantesFromMateria(selectedMateria.idMateria)[index];
  textNombres.text = estudiante.nombre;
  textApellidos.text = estudiante.apellidos;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Editar estudiante"),
        content: SizedBox(
          height: 150,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textNombres,
                  decoration: const InputDecoration(label: Text("Nombres")),
                ),
                TextField(
                  controller: textApellidos,
                  decoration: const InputDecoration(label: Text("Apellidos")),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  Estudiante updatedEstudiante = Estudiante(
                    idEstudiante: estudiante.idEstudiante,
                    cedula: estudiante.cedula,
                    nombre: textNombres.text,
                    apellidos: textApellidos.text,
                  );
                  await controlm.updateEstudiante(selectedMateria.idMateria, updatedEstudiante).then((value) {
                    Get.back();
                    Get.snackbar(
                      'Estudiante',
                      'Estudiante actualizado correctamente',
                      icon: const Icon(Icons.check),
                      duration: const Duration(seconds: 2),
                    );
                  });
                },
                child: const Text("Guardar"),
              ),
            ],
          )
        ],
      );
    },
  );
}
