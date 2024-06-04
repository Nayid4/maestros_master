import 'package:flutter/material.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;
  final MateriasController materiasController;
  final VoidCallback onEdit;

  const MateriaCard({
    Key? key,
    required this.materia,
    required this.materiasController,
    required this.onEdit,
  }) : super(key: key);

  String formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        //side: const BorderSide(color: Colors.purple, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: Colors.purple, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    materia.nombre,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: materia.dias.map((dia) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${dia.nombreDia}: ${formatTime(dia.horaInicio)} - ${formatTime(dia.horaFin)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    materiasController.deleteMateria(materia.idMateria).then((_) {
                      Get.snackbar("Materia", "Materia eliminada con éxito",
                          duration: const Duration(seconds: 3));
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
