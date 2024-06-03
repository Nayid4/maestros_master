import 'dias.dart';

class Materia {
  final String idMateria;
  final String idUsuario;
  final String nombre;
  final List<Dia> dias;

  Materia({
    required this.idMateria,
    required this.nombre,
    required this.idUsuario,
    required this.dias,
  });
}