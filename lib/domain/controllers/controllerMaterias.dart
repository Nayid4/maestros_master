import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerUsers.dart';
import 'package:maestros_master/peticiones/peticionesMateria.dart';
import 'package:maestros_master/domain/models/dias.dart';

import '../models/Materias.dart';

class MateriasController extends GetxController {
  final RxList<Grupo> MateriaFirebase = RxList<Grupo>([]);
  UsersController userc = Get.find();
  final RxString mensaje = "".obs;
  final DateTime d = DateTime.now();
  final RxString proximo = "".obs;

  Future<void> consultarGrupos(correo) async {
    List<Grupo> listafinal = [];
    QuerySnapshot query = await PeticionesMateria.consultarMaterias(correo);

    String id;
    String nombre;
    List<Dia> dias;
    List<dynamic> list;
    Map<String, dynamic> datos;
    DateTime d = DateTime.now();
    for (var doc in query.docs) {
      id = doc.id;
      datos = doc.data() as Map<String, dynamic>;
      nombre = datos['nombre'];
      list = datos['horario'];
      dias = [];
      for (var e in list) {
        dias.add(Dia(
            nombre: e['nombre'],
            horaInicio: formatHour(e['horaInicio']),
            horaFin: formatHour(e['horaFin'])));
      }

      Grupo grupo = Grupo(nombre: nombre, id: id, dias: dias);
      listafinal.add(grupo);
    }

    MateriaFirebase.value = listafinal;
  }

  Future<void> crearGrupo(nombre, dias, uid) async {
    Grupo g = Grupo(nombre: nombre, dias: dias, id: "");
    mensaje.value = await PeticionesMateria.guardarGrupo(g, uid);
    consultarGrupos(uid);
  }

  Future<void> eliminarGrupo(id) async {
    try {
      mensaje.value = await PeticionesMateria.eliminargrupo(id);
      consultarGrupos(userc.user!.email);
    } catch (e) {
      mensaje.value = "no se pudo eliminar";
    }
  }

  Future<void> updateGrupo(nombre, dias, id, uid) async {
    Grupo g = Grupo(nombre: nombre, id: id, dias: dias);
    mensaje.value = await PeticionesMateria.actualizarGrupo(g, uid);
    obtenerDiaMasProximo();
  }

  DateTime formatHour(String time) {
    List<String> s = time.split(":");
    DateTime d = DateTime.now();
    return DateTime(
        d.year, d.month, d.day, int.parse(s.first), int.parse(s.last));
  }

  void comprobarData() {
    if (MateriaFirebase.isEmpty) {
      consultarGrupos(userc.user?.email);
    }
  }

  obtenerDiaMasProximo() {
    final ahora = DateTime.now();
    int hour = 11;
    for (var g in MateriaFirebase) {
      for (var d in g.dias) {
        if ((ahora.weekday == 1 && d.nombre == "lunes") &&
            (ahora.hour < d.horaInicio.hour)) {
          proximo.value = "${d.nombre} - A las ${d.horaInicio.toString()}";
        }
        if ((ahora.weekday == 5 && d.nombre == "viernes") &&
            (ahora.hour < d.horaInicio.hour)) {
          if (hour > d.horaInicio.hour) {
            hour = d.horaInicio.hour;
            print(hour);
            proximo.value = "${d.nombre} - A las ${d.horaInicio.toString()}";
          }
        }
      }
    }
  }
}
