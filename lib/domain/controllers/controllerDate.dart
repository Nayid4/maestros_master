import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerMaterias.dart';
import 'package:maestros_master/domain/models/dias.dart';

class DateController extends GetxController {
  final MateriasController materiac = Get.find();
  final Rx<TimeOfDay> hora = Rx(const TimeOfDay(hour: 00, minute: 00));
  RxList<Dia> dias = <Dia>[].obs;
  RxList<Dia> dias2 = <Dia>[].obs;
  void cargarDias() {
    DateTime d = DateTime.now();
    dias.add(Dia(
        nombre: "Lunes",
        horaInicio: DateTime(d.year, d.month, d.day, 0, 0),
        horaFin: DateTime(d.year, d.month, d.day, 0, 0)));
  }

  void cargarDias2() {
    DateTime d = DateTime.now();
    dias2.add(Dia(
        nombre: "Lunes",
        horaInicio: DateTime(d.year, d.month, d.day, 0, 0),
        horaFin: DateTime(d.year, d.month, d.day, 0, 0)));
  }

  void cargarDiasEdit(int i) {
    dias2.value = materiac.MateriaFirebase[i].dias;
  }

  void eliminar(i) {
    dias.removeAt(i);
  }

  void eliminar2(i) {
    dias2.removeAt(i);
  }

  void setHoraInicio(int index, TimeOfDay t) {
    final d = DateTime.now();
    dias[index].horaInicio = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  void setHoraInicio2(int index, TimeOfDay t) {
    final d = DateTime.now();
    dias2[index].horaInicio =
        DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  void setHorafin(int index, TimeOfDay t) {
    final d = DateTime.now();
    dias[index].horaFin = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  void setHorafin2(int index, TimeOfDay t) {
    final d = DateTime.now();
    dias2[index].horaFin = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  void setDia(int index, String diaSemana) {
    dias[index].nombre = diaSemana;
    dias.refresh();
  }

  void setDia2(int index, String diaSemana) {
    dias2[index].nombre = diaSemana;
    dias2.refresh();
  }
}
