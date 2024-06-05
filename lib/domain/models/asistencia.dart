import 'package:maestros_master/domain/models/estado_asistencia.dart';

class Asistencia {
  final String idAsistencia;
  final String idMateria;
  final DateTime fecha;
  final List<EstadoAsistencia> estadoEstudiantes;

  Asistencia({
    required this.idAsistencia,
    required this.idMateria,
    required this.fecha,
    required this.estadoEstudiantes,
  });

  Map<String, dynamic> toMap() {
    return {
      'idAsistencia': idAsistencia,
      'idMateria': idMateria,
      'fecha': fecha.toIso8601String(),
      'estadoEstudiantes': estadoEstudiantes.map((e) => e.toMap()).toList(),
    };
  }

  factory Asistencia.fromMap(Map<String, dynamic> map) {
    return Asistencia(
      idAsistencia: map['idAsistencia'],
      idMateria: map['idMateria'],
      fecha: DateTime.parse(map['fecha']),
      estadoEstudiantes: List<EstadoAsistencia>.from(map['estadoEstudiantes']?.map((e) => EstadoAsistencia.fromMap(e))),
    );
  }
}


