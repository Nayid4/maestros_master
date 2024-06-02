import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerHorario.dart';
import 'package:maestros_master/domain/controllers/controllerMaterias.dart';
import 'package:maestros_master/domain/controllers/controllerUsers.dart';
import 'package:maestros_master/pages/utils/drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static Color micolor = const Color.fromRGBO(0, 191, 99, 1);

  @override
  Widget build(BuildContext context) {
    UsersController controlu = Get.find();
    MateriasController mc = Get.find();

    return Scaffold(
        appBar: AppBar(
          title: const Text("HOME"),
          backgroundColor: micolor,
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
                                child: const Text('Cancelar')),
                            TextButton(
                                onPressed: () {
                                  controlu.cerrarSesion();
                                  mc.MateriaFirebase.clear();
                                  Get.offAllNamed("/login");
                                },
                                child: const Text('Salir'))
                          ],
                          title: const Text('Cerrar sesion'),
                          content: const Text('Desea salir de la app?'),
                        );
                      });
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        drawer: const DrawerGlobal(),
        body: const Center(
          child: Column(
            children: [
              //const Boxdate(), Text(recuperarUsuario()),
               Text("Hola")           
            ],
          ),
        ));
  }
}

String recuperarUsuario() {
  UsersController controlu = Get.find();
  MateriasController mc = Get.find();
  String email = "";

  controlu
      .consultarUsuario()
      .then((value) => {email = controlu.user!.email.toString()});
  String? email2 = controlu.user!.email;
  email = email2 ?? '';
  mc.comprobarData();
  mc.obtenerDiaMasProximo();
  return "";
}

class Boxdate extends StatelessWidget {
  const Boxdate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MateriasController mc = Get.find();
    HorarioController hc = Get.find();
    mc.comprobarData();
    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.shade100,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "proxima clase",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(DateTime.now().toString()),
          )
        ],
      ),
    );
  }
}
