import 'package:flutter/cupertino.dart';

@immutable
class Estudiante {
  final String nombre;
  final String apellidos;
  final String id;
  final String classID;

  const Estudiante({
    required this.nombre,
    required this.apellidos,
    required this.id,
    required this.classID,
  });
}