import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_asistencia.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/asistencia.dart';
import 'package:maestros_master/domain/models/estado_asistencia.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/utils/drawer/drawer.dart';
import 'package:provider/provider.dart';
import './widgets/drop_down_button_widget.dart';
import './widgets/no_materia_selected_widget.dart';
import './widgets/asistencias_list.dart';
import 'package:uuid/uuid.dart'; // Importa la biblioteca uuid

class ViewAsistence extends StatefulWidget {
  const ViewAsistence({Key? key}) : super(key: key);

  @override
  _ViewAsistenceState createState() => _ViewAsistenceState();
}

class _ViewAsistenceState extends State<ViewAsistence> {
  Materia? selectedMateria;
  final AsistenciaController asistenciaController = Get.find();
  final MateriasController controlm = Get.find();
  final uuid = const Uuid(); // Instancia de la clase Uuid

  @override
  Widget build(BuildContext context) {
    const Color miColor = Color.fromRGBO(0, 191, 99, 1);
    final loginProvider = Provider.of<LoginProvider>(context);
    final String userId = loginProvider.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Asistencias", style: TextStyle(color: Colors.white)),
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
                userId: userId, // Ajusta esto según tu lógica de usuario
                selectedMateria: selectedMateria,
                onMateriaSelected: (materia) {
                  setState(() {
                    selectedMateria = materia;
                  });
                  asistenciaController.fetchAsistencias(materia.idMateria);
                },
              ),
            ],
          ),
          Expanded(
            child: selectedMateria != null
                ? Obx(() {
                    final List<Asistencia> asistencias = asistenciaController.asistencias;
                    return asistencias.isEmpty
                        ? const Center(child: Text("No hay asistencias registradas"))
                        : AsistenciasList(
                            asistencias: asistencias,
                            selectedMateria: selectedMateria!,
                            asistenciaController: asistenciaController,
                          );
                  })
                : const NoMateriaSelectedWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (selectedMateria != null) {
            _showRegistrarAsistenciaDialog(context, selectedMateria!);
          } else {
            _showNoMateriaSelectedDialog(context);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Registrar asistencia"),
      ),
    );
  }

  void _showRegistrarAsistenciaDialog(BuildContext context, Materia materia) {
    DateTime selectedDate = DateTime.now(); // Fecha seleccionada inicialmente

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Utiliza StatefulBuilder para actualizar el estado dentro del diálogo
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text("Registrar Asistencia"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("¿Desea registrar la asistencia para ${materia.nombre}?"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() { // Actualiza el estado de selectedDate dentro del StatefulBuilder
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Seleccionar fecha: ${selectedDate.toString().split(' ')[0]}'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    final asistencia = Asistencia(
                      idAsistencia: '${materia.idMateria}_${uuid.v4()}',
                      idMateria: materia.idMateria,
                      fecha: selectedDate,
                      estadoEstudiantes: materia.estudiantes.map((e) => EstadoAsistencia(
                        idEstado: uuid.v4(),
                        estudiante: e,
                        estado: 'ausente'
                      )).toList(),
                    );
                    asistenciaController.addAsistencia(asistencia);
                    Get.back();
                  },
                  child: const Text("Registrar"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showNoMateriaSelectedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selección de materia requerida"),
          content: const Text("Por favor seleccione una materia antes de registrar asistencia."),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}
