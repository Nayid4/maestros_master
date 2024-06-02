import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerHorario.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class ViewHorario extends StatelessWidget {
  ViewHorario({super.key});
  final HorarioController horarioc = Get.find();
  @override
  Widget build(BuildContext context) {
    horarioc.cargarClases();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Horario de clases"),
        ),
        body: Obx(() => SfCalendar(
              firstDayOfWeek: 1,
              view: CalendarView.week,
              dataSource: DataSource(horarioc.listaClases.value),
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 5,
                endHour: 23,
                nonWorkingDays: <int>[DateTime.sunday],
              ),
            )));
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
