import 'package:flutter/material.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'edit_materia_state.dart';

class EditMateria extends StatefulWidget {
  final Materia materia;
  const EditMateria({Key? key, required this.materia}) : super(key: key);

  @override
  EditMateriaState createState() => EditMateriaState();
}
