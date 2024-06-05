import 'package:flutter/material.dart';
import 'package:maestros_master/domain/controllers/controller_asistencia.dart';
import 'package:maestros_master/domain/models/asistencia.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'asistencia_item.dart';

class AsistenciasList extends StatelessWidget {
  final List<Asistencia> asistencias;
  final Materia selectedMateria;
  final AsistenciaController asistenciaController;

  const AsistenciasList({
    Key? key,
    required this.asistencias,
    required this.selectedMateria,
    required this.asistenciaController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: asistencias.length,
      itemBuilder: (BuildContext context, int index) {
        final asistencia = asistencias[index];
        return AsistenciaItem(
          asistencia: asistencia,
          asistenciaController: asistenciaController,
        );
      },
    );
  }
}
