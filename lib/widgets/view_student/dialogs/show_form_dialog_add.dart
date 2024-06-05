import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';

void showFormDialogAdd(BuildContext context, MateriasController controlm, Materia selectedMateria) {
  final TextEditingController textNombres = TextEditingController();
  final TextEditingController textApellidos = TextEditingController();
  final TextEditingController textCedula = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Añadir estudiante"),
        content: SizedBox(
          height: 180,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textCedula,
                  decoration: const InputDecoration(label: Text("Cedula")),
                ),
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
                  String idEstudiante = const Uuid().v4();
                  bool addedSuccessfully = await controlm.addEstudianteToMateria(
                    selectedMateria.idMateria,
                    Estudiante(
                      idEstudiante: idEstudiante,
                      cedula: textCedula.text,
                      nombre: textNombres.text,
                      apellidos: textApellidos.text,
                    ),
                  );
                  if (addedSuccessfully) {
                    Get.back();
                    Get.snackbar(
                      'Estudiante',
                      'Estudiante añadido correctamente',
                      icon: const Icon(Icons.check),
                      duration: const Duration(seconds: 2),
                    );
                  }
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
