import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/controllers/controllerUsers.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/utils/drawer/drawer.dart';
import 'package:provider/provider.dart';
import '../../widgets/option_card/option.dart'; // Importa la clase Option desde el archivo correspondiente
import '../../widgets/option_card/option_card.dart'; // Importa la clase OptionCard desde el archivo correspondiente

class Home extends StatelessWidget {
  const Home({super.key});
  static Color micolor = const Color.fromRGBO(0, 191, 99, 1);

  @override
  Widget build(BuildContext context) {
    //UsersController controlu = Get.find();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    List<Option> options = [
      Option(icon: Icons.school, name: 'Materias', route: '/materias', color: Colors.green),
      Option(icon: Icons.schedule, name: 'Horario', route: '/horario', color: Colors.blue),
      Option(icon: Icons.group, name: 'Estudiantes', route: '/estudiantes', color: Colors.orange),
      Option(icon: Icons.check_circle, name: 'Asistencia', route: '/asistencia', color: Colors.purple),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio", style: TextStyle(color: Colors.white)),
        backgroundColor: micolor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white), // Icono blanco
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre el cajón del menú
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          //controlu.cerrarSesion();
                          loginProvider.logoutUser();
                          Get.offAllNamed("/login");
                        },
                        child: const Text('Salir'),
                      ),
                    ],
                    title: const Text('Cerrar sesión'),
                    content: const Text('¿Desea salir de la app?'),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      drawer: const DrawerGlobal(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            return OptionCard(
              icon: options[index].icon,
              name: options[index].name,
              route: options[index].route,
              color: options[index].color,
            );
          },
        ),
      ),
    );
  }
}


