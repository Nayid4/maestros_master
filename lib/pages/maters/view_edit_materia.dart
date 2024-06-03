import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerDate.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/controllers/controllerUsers.dart';

class EditMateria extends StatelessWidget {
  const EditMateria({super.key, required this.i});
  final int i;
  @override
  Widget build(BuildContext context) {
    TextEditingController nombre = TextEditingController();
    MateriasController controlm = Get.find();
    UsersController controls = Get.find();
    DateController controld = Get.find();
    //nombre.text = controlm.MateriaFirebase[i].nombreDia;
    //scaffoldAdd(nombre: nombre, grupos: grupos, controlm: controlm, controls: controls);
    return  Text("data");/*scaffoldAdd(
      nombre: nombre,
      controlm: controlm,
      controls: controls,
      controld: controld,
      i: i,
    );*/
  }
}

/*class scaffoldAdd extends StatelessWidget {
  const scaffoldAdd({
    super.key,
    required this.nombre,
    required this.controlm,
    required this.controls,
    required this.controld,
    required this.i,
  });

  final TextEditingController nombre;
  final MateriasController controlm;
  final UsersController controls;
  final DateController controld;
  final int i;

  @override
  Widget build(BuildContext context) {
    controld.cargarDiasEdit(i);
    return WillPopScope(
      onWillPop: () async {
        controld.cargarDiasEdit(i);
        return true;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title:
                  Text("Modificar Grupo "),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  text_nombre(nombre: nombre),
                  IconButton(
                    onPressed: () {
                      controld.cargarDias2();
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: controld.dias2.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(controld.dias2[index].nombreDia),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      "Hora.I :${convertirADateTime(controld.dias2[index].horaInicio).format(context)}"),
                                  Text(
                                      ("Hora.F :${convertirADateTime(controld.dias2[index].horaFin).format(context)}")),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _showFormDialog(
                                            context, controld, index);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        controld.eliminar2(index);
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 60,
              elevation: 10,
              notchMargin: double.maxFinite,
              child: TextButton(
                  onPressed: () {
                    if (verificarCampos(nombre.text, controld)) {
                      /*controlm
                          .updateGrupo(
                              nombre.text,
                              controld.dias2,
                              controlm.MateriaFirebase[i].id,
                              controls.user!.email)
                          .then((value) {
                        Get.snackbar("Grupos", controlm.mensaje.string,
                            icon: const Icon(Icons.warning),
                            duration: const Duration(seconds: 3));
                      });*/
                      Get.back();
                    } else {
                      Get.snackbar(
                          "Grupos", "Digilencie los campos correctamente",
                          icon: const Icon(Icons.warning),
                          duration: const Duration(seconds: 3));
                    }
                  },
                  child: const Text(
                    "Guardar",
                    style: TextStyle(fontSize: 25),
                  )),
            )),
      ),
    );
  }
}

void _showTimePicker(context, index, int i) {
  DateController d = Get.find();
  showTimePicker(
          context: context, initialTime: const TimeOfDay(hour: 0, minute: 0))
      .then((value) {
    if (i == 1) {
      value == null ? TimeOfDay.now() : d.setHoraInicio2(index, value);
      d.dias2.refresh();
    } else {
      value == null ? TimeOfDay.now() : d.setHorafin2(index, value);
      d.dias2.refresh();
    }
  });
}

void _showFormDialog(context, DateController controld, index) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar horario"),
          content: SizedBox(
            height: 150,
            child: Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DropDownButton(controld, index),
                Obx(() => TextButton(
                    onPressed: () {
                      _showTimePicker(context, index, 1);
                    },
                    child: Text(
                        "Hora inicio :${convertirADateTime(controld.dias2[index].horaInicio).format(context)}",
                        style: const TextStyle(
                          color: Colors.black,
                        )))),
                Obx(() => TextButton(
                    onPressed: () {
                      _showTimePicker(context, index, 2);
                    },
                    child: Text(
                      "Hora inicio :${convertirADateTime(controld.dias2[index].horaFin).format(context)}",
                      style: const TextStyle(color: Colors.black),
                    ))),
              ],
            )),
          ),
        );
      });
}

bool verificarCampos(String n, DateController d) {
  if (n.isEmpty) {
    return false;
  }
  if (d.dias2.isEmpty) {
    return false;
  }

  return true;
}

TimeOfDay convertirADateTime(DateTime dt) {
  return TimeOfDay(hour: dt.hour, minute: dt.minute);
}

class text_nombre extends StatelessWidget {
  const text_nombre({
    super.key,
    required this.nombre,
  });

  final TextEditingController nombre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
      child: TextField(
        controller: nombre,
        decoration: InputDecoration(
            hintText: "Nombre de la materia",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        keyboardType: TextInputType.text,
      ),
    );
  }
}

_DropDownButton(DateController d, int i) {
  List dias = ["lunes", "martes", "miercoles", "jueves", "viernes", "sabado"];

  return DropdownButtonFormField(
      hint: const Text("Dia"),
      items: dias
          .map((dia) => DropdownMenuItem(
                value: dia,
                child: Text(dia),
              ))
          .toList(),
      onChanged: (value) {
        d.setDia2(i, value.toString());
      });
}
*/