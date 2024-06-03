import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerUsers.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import '../models/dias.dart';

class HorarioController extends GetxController {
  final RxList<Appointment> listaClases = RxList<Appointment>([]);
  final MateriasController materiac = Get.find();
  final UsersController userc = Get.find();

  void cargarClases() {
    if (listaClases.isEmpty) {
      /*materiac.consultarGrupos(userc.user!.email).then((value) {
        cargarEventos();
      });*/
    } else {
      cargarEventos();
    }
  }

  void cargarEventos() {
    listaClases.clear();
    DateTime diaActual;
    /*for (Grupo materia in materiac.MateriaFirebase) {
      for (var e in materia.dias) {
        diaActual = DateTime.now();
        Appointment appointment = Appointment(
            color: getRandomColor(),
            subject: materia.nombre,
            startTime: DateTime(diaActual.year, diaActual.month, diaActual.day,
                e.horaInicio.hour, e.horaInicio.minute),
            endTime: DateTime(diaActual.year, diaActual.month, diaActual.day,
                    e.horaInicio.hour, e.horaInicio.minute)
                .add(Duration(
                    hours: restarHora(e.horaInicio.hour, e.horaFin.hour))),
            recurrenceRule:
                "FREQ=WEEKLY;INTERVAL=1;BYDAY=${ruleDay(e.nombre)};UNTIL=20240908T183000Z");
        listaClases.add(appointment);
      }
    }*/
  }

  int restarHora(int hi, int hf) => hf - hi;

  String? ruleDay(String dia) {
    final Map<String, String> dias = {
      'lunes': 'MO',
      'martes': 'TU',
      'miercoles': 'WE',
      'jueves': 'TH',
      'viernes': 'FR',
      'sabado': 'SA',
      'domingo': 'SU'
    };

    return dias.containsKey(dia) ? dias[dia] : "";
  }

  DateTime fechaProxima(MateriasController c) {
    DateTime fechaActual = DateTime.now();
    DateTime fechaProxima = DateTime(9999);
    List<DateTime> fechas = [];
    /*for (Grupo g in c.MateriaFirebase) {
      for (Dia d in g.dias) {
        print(d.horaInicio);
        fechas.add(d.horaInicio);
      }
    }*/

    for (DateTime fecha in fechas) {
      if (fecha.isAfter(fechaActual) &&
          (fecha.isBefore(fechaProxima))) {
        fechaProxima = fecha;
      }
    }

    return fechaProxima;
  }
}

Color getRandomColor() {
  Random random = Random();
  int r = random.nextInt(256);
  int g = random.nextInt(256);
  int b = random.nextInt(256);
  return Color.fromARGB(255, r, g, b);
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

/*
 for (var e in materia.dias) {
        diaActual = determinarFechaInicial(e.nombre);
        RecurrenceProperties recurrence =
            RecurrenceProperties(startDate: diaActual);
        recurrence.recurrenceType = RecurrenceType.daily;
        recurrence.interval = 7;
        Appointment appointment = Appointment(
            color: getRandomColor(),
            subject: materia.nombre,
            startTime: DateTime(diaActual.year, diaActual.month, diaActual.day,
                e.horaInicio.hour, e.horaInicio.minute),
            endTime: DateTime(diaActual.year, diaActual.month, diaActual.day,
                    e.horaInicio.hour, e.horaInicio.minute)
                .add(Duration(
                    hours: restarHora(e.horaInicio.hour, e.horaFin.hour))),
            recurrenceRule: SfCalendar.generateRRule(recurrence, DateTime.now(),
                DateTime.now().add(const Duration(hours: 2))));
        listaClases.add(appointment);
      }
*/