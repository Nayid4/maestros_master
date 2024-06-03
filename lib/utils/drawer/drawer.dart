import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'drawer_menu_item.dart';

class DrawerGlobal extends StatelessWidget {
  const DrawerGlobal({Key? key});

  @override
  Widget build(BuildContext context) {
    //final userController = Get.find<UsersController>();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    final List<Map<String, dynamic>> drawerItemsInfo = [
      {
        'icon': Icons.home, // Icono para ir al inicio (home)
        'title': "Inicio", // Título para ir al inicio (home)
        'onTap': () {
          Get.offNamed("/home"); // Ir al inicio (home)
        },
      },
      {
        'icon': Icons.school,
        'title': "Materias",
        'onTap': () {
          Get.toNamed("/materias");
        },
      },
      {
        'icon': Icons.calendar_month,
        'title': "Horario",
        'onTap': () {
          Get.toNamed("/horario");
        },
      },
      {
        'icon': Icons.people_alt,
        'title': "Estudiantes",
        'onTap': () {
          Get.toNamed("/estudiantes");
        },
      },
      {
        'icon': Icons.checklist_rounded,
        'title': "Asistencia",
        'onTap': () {
          Get.toNamed("/asistencia");
        },
      },
      {
        'icon': Icons.logout, // Icono para cerrar sesión
        'title': "Cerrar sesión", // Título para cerrar sesión
        'onTap': () {
          loginProvider.logoutUser();
          Get.offAllNamed("/login");
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
