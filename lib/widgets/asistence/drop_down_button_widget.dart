import 'package:flutter/material.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/materias.dart';

class DropDownButtonWidget extends StatelessWidget {
  final MateriasController controlm;
  final String userId;
  final Materia? selectedMateria;
  final Function(Materia) onMateriaSelected;

  const DropDownButtonWidget({
    Key? key,
    required this.controlm,
    required this.userId,
    required this.selectedMateria,
    required this.onMateriaSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Materia>>(
      future: controlm.fetchMaterias(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Materia> list = snapshot.data!;
          return SizedBox(
            width: 200,
            child: DropdownButtonFormField(
              value: selectedMateria?.idMateria,
              hint: const Text("Seleccione la materia"),
              alignment: Alignment.centerLeft,
              items: list.map((materia) => DropdownMenuItem(
                value: materia.idMateria,
                child: Text(materia.nombre),
              )).toList(),
              onChanged: (value) {
                onMateriaSelected(list.firstWhere((materia) => materia.idMateria == value));
              },
            ),
          );
        }
      },
    );
  }
}
