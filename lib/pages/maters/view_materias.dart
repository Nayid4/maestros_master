import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/pages/maters/view_edit_materia.dart';
import 'package:maestros_master/utils/drawer/drawer.dart'; // Importa el DrawerGlobal
import 'package:provider/provider.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/domain/models/materias.dart';

class ViewMaterias extends StatefulWidget {
  const ViewMaterias({Key? key}) : super(key: key);

  @override
  _ViewMateriasState createState() => _ViewMateriasState();
}

class _ViewMateriasState extends State<ViewMaterias> {
  static const Color miColor = Color.fromRGBO(0, 191, 99, 1);

  // Función para navegar a la pantalla de agregar materia
  void _navigateToAddMateria(BuildContext context) async {
    final result = await Get.toNamed("/materiasAdd");

    // Obtener el ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Verificar si el ScaffoldMessenger está en estado de montaje
    if (scaffoldMessenger.mounted) {
      // Actualiza la lista de materias si el resultado es verdadero
      if (result == true) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Materia agregada con éxito'),
            duration: Duration(seconds: 2),
          ),
        );

        // Actualizar la lista de materias después de agregar una nueva
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final MateriasController materiasController = Get.find();
    final loginProvider = Provider.of<LoginProvider>(context);
    final String userId = loginProvider.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Materias", style: TextStyle(color: Colors.white)),
        backgroundColor: miColor,
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
      ),
      drawer: const DrawerGlobal(),
      body: FutureBuilder<List<Materia>>(
        future: materiasController.fetchMaterias(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay materias'));
          } else {
            final materias = snapshot.data!;
            return ListView.builder(
              itemCount: materias.length,
              itemBuilder: (BuildContext context, int index) {
                final materia = materias[index];
                return Card(
                  elevation: 2,
                  color: const Color.fromARGB(255, 218, 226, 220),
                  child: ListTile(
                    leading: const Icon(Icons.school, color: Colors.purple, size: 30),
                    title: Text(materia.nombre),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            materiasController.deleteMateria(materia.idMateria).then((_) {
                              Get.snackbar("Materia", "Materia eliminada con éxito",
                                  duration: const Duration(seconds: 3));
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(() => EditMateria(i: index));
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddMateria(context);
        },
        backgroundColor: miColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
