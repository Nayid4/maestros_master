import 'package:flutter/material.dart';

class Dia {
  final String idDia;
  final String nombreDia;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;

  Dia({
    required this.idDia,
    required this.nombreDia,
    required this.horaInicio,
    required this.horaFin,
  });
}
