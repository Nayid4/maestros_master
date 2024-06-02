import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/controllers/controllerMaterias.dart';
import '../../domain/controllers/controllerUsers.dart';

class DrawerGlobal extends StatelessWidget {
  const DrawerGlobal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MateriasController materiac = Get.find();
    UsersController userc = Get.find();
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 191, 99, 1),
              borderRadius: BorderRadius.circular(10)),
          child: Image.asset("assets/ic_launcher.png"),
        ),
        Card(
          elevation: 2,
          child: ListTile(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school),
                Center(child: Text("Materias"))
              ],
            ),
            onTap: () {
              materiac
                  .consultarGrupos(userc.user?.email)
                  .then((value) => Get.toNamed("/materias"));
            },
          ),
        ),
        Card(
          elevation: 2,
          child: ListTile(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month),
                Center(child: Text("Horario"))
              ],
            ),
            onTap: () {
              materiac.comprobarData();
              Get.toNamed("/horario");
            },
          ),
        ),
        Card(
          elevation: 2,
          child: ListTile(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_alt),
                Center(child: Text("Estudiantes"))
              ],
            ),
            onTap: () {
              materiac.comprobarData();
              Get.toNamed("/listas");
            },
          ),
        ),
        Card(
          elevation: 1,
          child: ListTile(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checklist_rounded),
                Center(child: Text("Asistencia"))
              ],
            ),
            onTap: () {
              materiac.comprobarData();
              Get.toNamed("/listaAsistencia");
            },
          ),
        ),
      ]),
    );
  }
}
