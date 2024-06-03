import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/controllers/controllerStudent.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/models/estudiante.dart';

class ListStudent extends StatelessWidget {
  const ListStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController controle = Get.find();
    final MateriasController controlm = Get.find();

    return WillPopScope(
      onWillPop: () async {
        controle.listaEstudiante.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Estudiantes"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Grupos : "),
                _dropDownButton(controlm, controle)
              ],
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controle.listaEstudiante.isEmpty
                        ? 1
                        : controle.listaEstudiante.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (controle.listaEstudiante.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 0.3 * MediaQuery.of(context).size.height,
                            ),
                            const ListTile(
                              title: Text(
                                "Añade estudiantes a este grupo!",
                                style: TextStyle(
                                    color: Colors.black26, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          confirmDismiss: (direction) async {
                            bool confirmar = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmar eliminacion"),
                                    content: const Text(
                                        "Desea eliminar este estudiante?"),
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
                                });

                            if (confirmar) {
                              controle
                                  .eliminarEstudiante(
                                      controle.listaEstudiante[index].id)
                                  .then((value) {
                                Get.snackbar(
                                    "Estudiantes", controle.mensaje.value,
                                    duration: const Duration(seconds: 2),
                                    icon: const Icon(Icons.warning));
                              });
                              return true;
                            }
                            return null;
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              trailing: IconButton(
                                  onPressed: () {
                                    _showFormDialogEdit(
                                        context, controle, index);
                                  },
                                  icon: const Icon(Icons.edit)),
                              leading: Icon(
                                Icons.perm_contact_calendar_sharp,
                                color: Colors.greenAccent.shade400,
                                size: 40,
                              ),
                              title: Text(
                                  "Nombres:${controle.listaEstudiante[index].nombre}"),
                              subtitle: Text(
                                  "Apellidos  :${controle.listaEstudiante[index].apellidos}"),
                            ),
                          ),
                        );
                      }
                    },
                  )),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showFormDialogAdd(context, controle);
          },
          icon: const Icon(Icons.add),
          label: const Text("Añadir estudiante"),
        ),
      ),
    );
  }
}

_dropDownButton(MateriasController mc, StudentController sc) {
  /*List<Grupo> list = mc.MateriaFirebase;
  return Obx(() => SizedBox(
        width: 200,
        child: DropdownButtonFormField(
            hint: const Text("Seleccione el grupo"),
            alignment: Alignment.centerLeft,
            items: list
                .map((grupo) => DropdownMenuItem(
                      value: grupo.nombre,
                      child: Text(grupo.nombre),
                    ))
                .toList(),
            onChanged: (value) {
              for (var m in list) {
                if (m.nombre == value) {
                  sc.idclass.value = m.id;
                }
              }

              sc.cargarEstudiantes();
            }),
      ));*/
}

_showFormDialogAdd(context, StudentController controls) {
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
                  decoration: const InputDecoration(label: Text("Apellidos")),
                ),
              ],
            )),
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
                      await controls
                          .guardarEstudiantes(textNombres.text,
                              textApellidos.text, textCedula.text)
                          .then((value) {
                        Get.back();
                        Get.snackbar('Estudiante', controls.mensaje.value,
                            icon: const Icon(Icons.dangerous),
                            duration: const Duration(seconds: 2));
                      });
                    },
                    child: const Text("Guardar")),
              ],
            )
          ],
        );
      });
}

_showFormDialogEdit(context, StudentController controls, int index) {
  final TextEditingController textNombres = TextEditingController();
  final TextEditingController textApellidos = TextEditingController();
  textNombres.text = controls.listaEstudiante[index].nombre;
  textApellidos.text = controls.listaEstudiante[index].apellidos;
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
                  decoration: const InputDecoration(label: Text("Apellidos")),
                ),
              ],
            )),
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
                      await controls
                          .editarEstudiante(Estudiante(
                              nombre: textNombres.text,
                              apellidos: textApellidos.text,
                              id: controls.listaEstudiante[index].id,
                              classID: controls.listaEstudiante[index].classID))
                          .then((value) {
                        Get.back();
                        Get.snackbar('Estudiante', controls.mensaje.value,
                            icon: const Icon(Icons.dangerous),
                            duration: const Duration(seconds: 2));
                      });
                    },
                    child: const Text("Guardar")),
              ],
            )
          ],
        );
      });
}

bool comprobarCampos(String n, String a) {
  if (n.isEmpty || a.isEmpty) {
    return true;
  } else {
    return false;
  }
}
