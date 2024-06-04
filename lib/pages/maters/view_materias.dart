import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/utils/drawer/drawer.dart';
import 'package:provider/provider.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/widgets/card_materia/card_materia.dart';

class ViewMaterias extends StatefulWidget {
  const ViewMaterias({Key? key}) : super(key: key);

  @override
  _ViewMateriasState createState() => _ViewMateriasState();
}

class _ViewMateriasState extends State<ViewMaterias> {
  static const Color miColor = Color.fromRGBO(0, 191, 99, 1);

  void _navigateToAddMateria(BuildContext context) async {
    final result = await Get.toNamed("/materiasAdd");
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (scaffoldMessenger.mounted) {
      if (result == true) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Materia agregada con éxito'),
            duration: Duration(seconds: 2),
          ),
        );
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
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
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
                return MateriaCard(
                  materia: materia,
                  materiasController: materiasController,
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
