import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerDate.dart';
import 'package:maestros_master/domain/controllers/controllerMaterias.dart';
import 'package:maestros_master/domain/controllers/controllerUsers.dart';

class AddMaterias extends StatelessWidget {
  const AddMaterias({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nombre = TextEditingController();
    TextEditingController grupos = TextEditingController();
    MateriasController controlm = Get.find();
    UsersController controls = Get.find();
    DateController controld = Get.find();
    //scaffoldAdd(nombre: nombre, grupos: grupos, controlm: controlm, controls: controls);
    return scaffoldAdd(
      nombre: nombre,
      grupos: grupos,
      controlm: controlm,
      controls: controls,
      controld: controld,
    );
  }
}

class scaffoldAdd extends StatelessWidget {
  const scaffoldAdd({
    super.key,
    required this.nombre,
    required this.grupos,
    required this.controlm,
    required this.controls,
    required this.controld,
  });

  final TextEditingController nombre;
  final TextEditingController grupos;
  final MateriasController controlm;
  final UsersController controls;
  final DateController controld;

  @override
  Widget build(BuildContext context) {
    controld.dias.clear();
    return WillPopScope(
      onWillPop: () async {
        controld.dias.clear();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Agregar Materia"),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                text_nombre(nombre: nombre),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Fecha de finalizacion: '),
                    IconButton(
                        onPressed: () {
                          _showDatePicker(context);
                        },
                        icon: const Icon(Icons.calendar_month_outlined))
                  ],
                ),
                IconButton(
                  onPressed: () {
                    controld.cargarDias();
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controld.dias.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(controld.dias[index].nombre),
                            subtitle: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Hora.I: ${convertirADateTime(controld.dias[index].horaInicio).format(context)}"),
                                Text(
                                    (" - Hora.F: ${convertirADateTime(controld.dias[index].horaFin).format(context)}")),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _showFormDialog(context, controld, index);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      controld.eliminar(index);
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
                    controlm
                        .crearGrupo(
                            nombre.text, controld.dias, controls.user!.email)
                        .then((value) {
                      Get.snackbar("Grupos", controlm.mensaje.string,
                          icon: const Icon(Icons.warning),
                          duration: const Duration(seconds: 3));
                    });
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
    );
  }
}

void _showTimePicker(context, index, int i) {
  DateController d = Get.find();
  showTimePicker(
          context: context, initialTime: const TimeOfDay(hour: 0, minute: 0))
      .then((value) {
    if (i == 1) {
      value == null ? TimeOfDay.now() : d.setHoraInicio(index, value);
      d.dias.refresh();
    } else {
      value == null ? TimeOfDay.now() : d.setHorafin(index, value);
      d.dias.refresh();
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
                _dropDownButton(controld, index),
                Obx(() => TextButton(
                    onPressed: () {
                      _showTimePicker(context, index, 1);
                    },
                    child: Text(
                        "Hora inicio :${convertirADateTime(controld.dias[index].horaInicio).format(context)}",
                        style: const TextStyle(
                          color: Colors.black,
                        )))),
                Obx(() => TextButton(
                    onPressed: () {
                      _showTimePicker(context, index, 2);
                    },
                    child: Text(
                      "Hora fin     :${convertirADateTime(controld.dias[index].horaFin).format(context)}",
                      style: const TextStyle(color: Colors.black),
                    ))),
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
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("confirmar")),
              ],
            )
          ],
        );
      });
}

bool verificarCampos(String n, DateController d) {
  if (n.isEmpty) {
    return false;
  }
  if (d.dias.isEmpty) {
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
            label: const Text("Nombre del grupo"),
            hintText: "ejemplo 1 - g01",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        keyboardType: TextInputType.text,
      ),
    );
  }
}

_dropDownButton(DateController d, int i) {
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
        d.setDia(i, value.toString());
      });
}

void _showDatePicker(context) {
  showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2023),
    lastDate: DateTime(2055),
  );
}
