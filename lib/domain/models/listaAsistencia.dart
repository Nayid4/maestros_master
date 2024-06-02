import 'package:maestros_master/domain/models/estudiante.dart';

class Asistencia {
  Estudiante e;
  bool asistio = false;
  bool excusa = false;
  Asistencia({required this.e, required this.asistio, required this.excusa});
}
