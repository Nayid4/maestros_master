import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import '../dialogs/show_form_dialog_edit.dart';
import '../dialogs/show_confirmation_dialog.dart';

class EstudiantesList extends StatelessWidget {
  final List<Estudiante> estudiantes;
  final MateriasController controlm;
  final Materia selectedMateria;

  const EstudiantesList({
    Key? key,
    required this.estudiantes,
    required this.controlm,
    required this.selectedMateria,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: estudiantes.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
          confirmDismiss: (direction) async {
            bool confirmar = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirmar eliminación"),
                  content: const Text("¿Desea eliminar este estudiante?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back(result: false);
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () {
                          Get.back(result: true);
                        },
                        child: const Text("Confirmar"))
                  ],
                );
              },
            );

            if (confirmar) {
              await controlm.removeEstudianteFromMateria(
                  selectedMateria.idMateria, estudiantes[index].idEstudiante);
              return true;
            }
            return false;
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      showFormDialogEdit(context, controlm, selectedMateria, index);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      showConfirmationDialog(context, controlm, selectedMateria, index);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              leading: Icon(
                Icons.perm_contact_calendar_sharp,
                color: Colors.greenAccent.shade400,
                size: 40,
              ),
              title: Text("${estudiantes[index].nombre} ${estudiantes[index].apellidos}"),
              subtitle: Text("CC ${estudiantes[index].cedula}"),
            ),
          ),
        );
      },
    );
  }
}
