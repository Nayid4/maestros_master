import 'package:maestros_master/domain/models/estudiante.dart';

class EstadoAsistencia {
  final String idEstado;
  final Estudiante estudiante;
  String estado; // presente, ausente, tarde, etc.

  EstadoAsistencia({
    required this.idEstado,
    required this.estudiante,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'idEstado': idEstado,
      'estudiante': estudiante.toMap(),
      'estado': estado,
    };
  }

  factory EstadoAsistencia.fromMap(Map<String, dynamic> map) {
    return EstadoAsistencia(
      idEstado: map['idEstado'],
      estudiante: Estudiante.fromMap(map['estudiante']),
      estado: map['estado'],
    );
  }
}
