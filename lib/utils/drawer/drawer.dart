import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/controllers/controllerMaterias.dart';
import '../../domain/controllers/controllerUsers.dart';
import 'drawer_menu_item.dart';

class DrawerGlobal extends StatelessWidget {
  const DrawerGlobal({Key? key});

  @override
  Widget build(BuildContext context) {
    final materiasController = Get.find<MateriasController>();
    final userController = Get.find<UsersController>();

    final List<Map<String, dynamic>> drawerItemsInfo = [
      {
        'icon': Icons.school,
        'title': "Materias",
        'onTap': () {
          materiasController
              .consultarGrupos(userController.user?.email)
              .then((_) => Get.toNamed("/materias"));
        },
      },
      {
        'icon': Icons.calendar_month,
        'title': "Horario",
        'onTap': () {
          materiasController.comprobarData();
          Get.toNamed("/horario");
        },
      },
      {
        'icon': Icons.people_alt,
        'title': "Estudiantes",
        'onTap': () {
          materiasController.comprobarData();
          Get.toNamed("/estudiantes");
        },
      },
      {
        'icon': Icons.checklist_rounded,
        'title': "Asistencia",
        'onTap': () {
          materiasController.comprobarData();
          Get.toNamed("/asistencia");
        },
      },
    ];

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 191, 99, 1),
              //borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/ic_launcher.png"),
          ),
          for (final itemInfo in drawerItemsInfo)
            DrawerMenuItem(
              icon: itemInfo['icon'],
              title: itemInfo['title'],
              onTap: itemInfo['onTap'],
            ),
        ],
      ),
    );
  }
}
