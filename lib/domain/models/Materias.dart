import 'package:maestros_master/domain/models/estudiante.dart';
import 'dias.dart';

class Materia {
  final String idMateria;
  final String idUsuario;
  final String nombre;
  final List<Dia> dias;
  final List<Estudiante> estudiantes;

  Materia({
    required this.idMateria,
    required this.nombre,
    required this.idUsuario,
    required this.dias,
    required this.estudiantes,
  });

  Map<String, dynamic> toMap() {
    return {
      'idMateria': idMateria,
      'idUsuario': idUsuario,
      'nombre': nombre,
      'dias': dias.map((dia) => dia.toMap()).toList(),
      'estudiantes': estudiantes.map((estudiante) => estudiante.toMap()).toList(),
    };
  }

  factory Materia.fromMap(Map<String, dynamic> map) {
    return Materia(
      idMateria: map['idMateria'],
      idUsuario: map['idUsuario'],
      nombre: map['nombre'],
      dias: List<Dia>.from(map['dias'].map((dia) => Dia.fromMap(dia))),
      estudiantes: List<Estudiante>.from(map['estudiantes'].map((estudiante) => Estudiante.fromMap(estudiante))),
    );
  }
}
