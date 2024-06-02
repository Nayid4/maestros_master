import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerAsistencia.dart';
import 'package:maestros_master/domain/controllers/controllerMaterias.dart';
import 'package:maestros_master/domain/controllers/controllerStudent.dart';
import 'package:maestros_master/domain/models/Materias.dart';

class ListAssistanceStudent extends StatelessWidget {
  const ListAssistanceStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController controle = Get.find();
    final MateriasController controlm = Get.find();
    final AsistenciaController controla = Get.find();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        controle.listaEstudiante.clear();
        controla.excusa.clear();
        controla.asistio.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lista de asistencia"),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Grupos : "),
              _dropDownButton(controlm, controle, controla)
            ],
          ),
          Expanded(
              child: Obx(
            () => ListView.builder(
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
                          "Selecciona el grupo",
                          style: TextStyle(color: Colors.black26, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Asistio"),
                                Obx(() => Checkbox(
                                    value: controla.asistio[index],
                                    onChanged: (value) {
                                      controla.cambiarAsistencia(
                                          index, value ?? false);
                                    })),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Excusa"),
                                Obx(() => Checkbox(
                                    value: controla.excusa[index],
                                    onChanged: (value) {
                                      controla.cambiarExcusa(
                                          index, value ?? false);
                                    })),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  );
                }
              },
            ),
          ))
        ]),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Guardar asistencia"),
          ),
        ),
      ),
    );
  }
}

_dropDownButton(
    MateriasController mc, StudentController sc, AsistenciaController ac) {
  List<Grupo> list = mc.MateriaFirebase;
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

              sc.cargarEstudiantes().then((value) {
                ac.cargarAsistencia();
              });
            }),
      ));
}

bool comprobarCampos(String n, String a) {
  if (n.isEmpty || a.isEmpty) {
    return true;
  } else {
    return false;
  }
}
