import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/utils/drawer/drawer.dart';
import 'package:provider/provider.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/widgets/view_student/dialogs/show_form_dialog_add.dart';
import 'package:maestros_master/widgets/view_student/dialogs/show_no_materia_selected_dialog.dart';
import 'package:maestros_master/widgets/view_student/widgets/drop_down_button_widget.dart';
import 'package:maestros_master/widgets/view_student/widgets/no_estudiantes_widget.dart';
import 'package:maestros_master/widgets/view_student/widgets/estudiantes_list.dart';
import 'package:maestros_master/widgets/view_student/widgets/no_materia_selected_widget.dart';

class ListStudent extends StatefulWidget {
  const ListStudent({Key? key}) : super(key: key);

  @override
  _ListStudentState createState() => _ListStudentState();
}

class _ListStudentState extends State<ListStudent> {
  Materia? selectedMateria;
  MateriasController controlm = Get.find();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final String userId = loginProvider.currentUser?.uid ?? '';

    const Color miColor = Color.fromRGBO(0, 191, 99, 1);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Estudiantes", style: TextStyle(color: Colors.white)),
          backgroundColor: miColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: const DrawerGlobal(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Materia : "),
                DropDownButtonWidget(
                  controlm: controlm,
                  userId: userId,
                  selectedMateria: selectedMateria,
                  onMateriaSelected: (materia) {
                    setState(() {
                      selectedMateria = materia;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: selectedMateria != null
                  ? Obx(() {
                      final List<Estudiante> estudiantes = controlm.getEstudiantesFromMateria(selectedMateria!.idMateria);
                      return estudiantes.isEmpty
                          ? const NoEstudiantesWidget()
                          : EstudiantesList(
                              estudiantes: estudiantes,
                              controlm: controlm,
                              selectedMateria: selectedMateria!,
                            );
                    })
                  : const NoMateriaSelectedWidget(),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (selectedMateria != null) {
              showFormDialogAdd(context, controlm, selectedMateria!);
            } else {
              showNoMateriaSelectedDialog(context);
            }
          },
          icon: const Icon(Icons.add),
          label: const Text("Añadir estudiante"),
        ),
      ),
    );
  }
}
