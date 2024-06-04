import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/utils/drawer/drawer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ViewHorario extends StatelessWidget {
  ViewHorario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MateriasController materiasController = Get.find();
    final loginProvider = Provider.of<LoginProvider>(context);
    final String userId = loginProvider.currentUser?.uid ?? '';

    int _obtenerNumeroDia(String nombreDia) {
      switch (nombreDia.toLowerCase()) {
        case 'lunes':
          return DateTime.monday;
        case 'martes':
          return DateTime.tuesday;
        case 'miércoles':
          return DateTime.wednesday;
        case 'jueves':
          return DateTime.thursday;
        case 'viernes':
          return DateTime.friday;
        case 'sábado':
          return DateTime.saturday;
        case 'domingo':
          return DateTime.sunday;
        default:
          return 0; // Valor por defecto si el nombre del día no coincide
      }
    }

    const Color miColor = Color.fromRGBO(0, 191, 99, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Horario de clases", style: TextStyle(color: Colors.white)),
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
      body: FutureBuilder<List<Materia>>(
        future: materiasController.fetchMaterias(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Materia> materias = snapshot.data ?? [];
            final List<Appointment> appointments = [];

            for (final materia in materias) {
              for (final dia in materia.dias) {
                final numeroDia = _obtenerNumeroDia(dia.nombreDia);
                final startDateTime = DateTime(2024, 1, 1, dia.horaInicio.hour, dia.horaInicio.minute); // Usamos una fecha fija (1 de enero de 2024) para representar el inicio del evento
                final endDateTime = DateTime(2024, 1, 1, dia.horaFin.hour, dia.horaFin.minute); // Usamos una fecha fija (1 de enero de 2024) para representar el final del evento

                for (int weekOffset = 0; weekOffset < 52; weekOffset++) { // Generamos eventos para cada semana del año
                  final weekStartDateTime = startDateTime.add(Duration(days: numeroDia - startDateTime.weekday + (7 * weekOffset)));
                  final weekEndDateTime = endDateTime.add(Duration(days: numeroDia - startDateTime.weekday + (7 * weekOffset)));

                  appointments.add(
                    Appointment(
                      startTime: weekStartDateTime,
                      endTime: weekEndDateTime,
                      subject: materia.nombre,
                    ),
                  );
                }
              }
            }

            return SfCalendar(
              firstDayOfWeek: 1,
              view: CalendarView.week,
              dataSource: DataSource(appointments),
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 5,
                endHour: 23,
                nonWorkingDays: <int>[DateTime.sunday],
              ),
            );
          }
        },
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
