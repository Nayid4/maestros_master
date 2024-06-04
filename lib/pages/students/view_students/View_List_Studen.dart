import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/utils/drawer/drawer.dart';
import 'package:uuid/uuid.dart'; // Importa la librería uuid

class ListStudent extends StatefulWidget {
  const ListStudent({Key? key});

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
                _dropDownButton(controlm, userId), // Pasa userId como parámetro
              ],
            ),
            Expanded(
              child: selectedMateria != null
                  ? Obx(() {
                      final List<Estudiante> estudiantes = controlm.getEstudiantesFromMateria(selectedMateria!.idMateria);
                      return estudiantes.isEmpty
                          ? _buildNoEstudiantesWidget()
                          : _buildEstudiantesList(estudiantes);
                    })
                  : _buildNoMateriaSelectedWidget(),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (selectedMateria != null) {
              _showFormDialogAdd(context, controlm);
            } else {
              _showNoMateriaSelectedDialog(context);
            }
          },
          icon: const Icon(Icons.add),
          label: const Text("Añadir estudiante"),
        ),
      ),
    );
  }

  Widget _dropDownButton(MateriasController mc, String userId) {
    return FutureBuilder<List<Materia>>(
      future: controlm.fetchMaterias(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Materia> list = snapshot.data!;
          return SizedBox(
            width: 200,
            child: DropdownButtonFormField(
              value: selectedMateria?.idMateria, // Mantiene la selección actual
              hint: const Text("Seleccione la materia"),
              alignment: Alignment.centerLeft,
              items: list
                  .map((materia) => DropdownMenuItem(
                        value: materia.idMateria,
                        child: Text(materia.nombre),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedMateria =
                      list.firstWhere((materia) => materia.idMateria == value);
                });
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildNoEstudiantesWidget() {
    return Column(
      children: [
        SizedBox(
          height: 0.3 * MediaQuery.of(context).size.height,
        ),
        const ListTile(
          title: Text(
            "No hay estudiantes en esta materia",
            style: TextStyle(color: Colors.black26, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildEstudiantesList(List<Estudiante> estudiantes) {
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
                  selectedMateria!.idMateria, estudiantes[index].idEstudiante);
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
                      _showFormDialogEdit(context, controlm, index);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _showConfirmationDialog(context, controlm, index);
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
              title: Text("Nombres: ${estudiantes[index].nombre}"),
              subtitle: Text("Apellidos:${estudiantes[index].apellidos}"),
            ),
          ),

        );
      },
    );
  }

  void _showConfirmationDialog(
    BuildContext context, MateriasController controlm, int index) {
      final Estudiante estudiante =
        controlm.getEstudiantesFromMateria(selectedMateria!.idMateria)[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: const Text("¿Desea eliminar este estudiante?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await controlm.removeEstudianteFromMateria(
                    selectedMateria!.idMateria, estudiante.idEstudiante);
                Navigator.of(context).pop();
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }


  Widget _buildNoMateriaSelectedWidget() {
    return Column(
      children: [
        SizedBox(
          height: 0.3 * MediaQuery.of(context).size.height,
        ),
        const ListTile(
          title: Text(
            "No se ha seleccionado una materia",
            style: TextStyle(color: Colors.black26, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _showFormDialogAdd(
      BuildContext context, MateriasController controlm) {
    final TextEditingController textNombres = TextEditingController();
    final TextEditingController textApellidos = TextEditingController();
    final TextEditingController textCedula = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Añadir estudiante"),
          content: SizedBox(
            height: 180,
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textCedula,
                    decoration: const InputDecoration(label: Text("Cedula")),
                  ),
                  TextField(
                    controller: textNombres,
                    decoration: const InputDecoration(label: Text("Nombres")),
                  ),
                  TextField(
                    controller: textApellidos,
                    decoration:
                        const InputDecoration(label: Text("Apellidos")),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                    onPressed: () async {
                      String idEstudiante = Uuid().v4();
                      await controlm
                          .addEstudianteToMateria(
                              selectedMateria!.idMateria,
                              Estudiante(
                                idEstudiante: idEstudiante,
                                cedula: textCedula.text,
                                nombre: textNombres.text,
                                apellidos: textApellidos.text,
                              ))
                          .then((value) {
                        Get.back();
                        Get.snackbar('Estudiante',
                            'Estudiante añadido correctamente',
                            icon: const Icon(Icons.check),
                            duration: const Duration(seconds: 2));
                      });
                    },
                    child: const Text("Guardar")),
              ],
            )
          ],
        );
      },
    );
  }

  void _showFormDialogEdit(
      BuildContext context, MateriasController controlm, int index) {
    final TextEditingController textNombres = TextEditingController();
    final TextEditingController textApellidos = TextEditingController();
    final Estudiante estudiante =
        controlm.getEstudiantesFromMateria(selectedMateria!.idMateria)[index];
    textNombres.text = estudiante.nombre;
    textApellidos.text = estudiante.apellidos;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar estudiante"),
          content: SizedBox(
            height: 150,
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textNombres,
                    decoration: const InputDecoration(label: Text("Nombres")),
                  ),
                  TextField(
                    controller: textApellidos,
                    decoration:
                        const InputDecoration(label: Text("Apellidos")),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                    onPressed: () async {
                      Estudiante updatedEstudiante = Estudiante(
                        idEstudiante: estudiante.idEstudiante,
                        cedula: estudiante.cedula,
                        nombre: textNombres.text,
                        apellidos: textApellidos.text,
                      );
                      await controlm
                      .updateEstudiante(selectedMateria!.idMateria, updatedEstudiante)
                      .then((value) {
                        Get.back();
                        Get.snackbar('Estudiante',
                          'Estudiante actualizado correctamente',
                          icon: const Icon(Icons.check),
                          duration: const Duration(seconds: 2));
                      });

                    },
                    child: const Text("Guardar")),
              ],
            )
          ],
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
          content: const Text("Por favor seleccione una materia antes de añadir un estudiante."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

