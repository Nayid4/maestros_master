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
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Editar estudiante"),
        content: SizedBox(
          height: 250,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: textNombres,
                  decoration: const InputDecoration(label: Text("Nombres")),
                  validator: validateNombre,
                ),
                TextFormField(
                  controller: textApellidos,
                  decoration: const InputDecoration(label: Text("Apellidos")),
                  validator: validateApellido,
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
                  if (_formKey.currentState!.validate()) {
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

String? validateCedula(String? cedula) {
  if (cedula == null || cedula.isEmpty) return 'La cedula es obligatoria';
  if (cedula.length < 8) return 'La cedula debe tener al menos 8 dígitos';
  if (cedula.length > 10) return 'La cedula no debe exceder los 10 dígitos';
  if (!RegExp(r'^\d+$').hasMatch(cedula)) return 'La cedula debe ser numérica';
  return null;
}

String? validateNombre(String? nombre) {
  if (nombre == null || nombre.isEmpty) return 'El nombre es obligatorio';
  if (nombre.length > 100) return 'El nombre no debe exceder los 100 caracteres';
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nombre)) return 'El nombre debe contener solo caracteres alfabéticos';
  return null;
}

String? validateApellido(String? apellido) {
  if (apellido == null || apellido.isEmpty) return 'El apellido es obligatorio';
  if (apellido.length > 100) return 'El apellido no debe exceder los 100 caracteres';
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(apellido)) return 'El apellido debe contener solo caracteres alfabéticos';
  return null;
}
