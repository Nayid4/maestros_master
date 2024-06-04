import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNoMateriaSelectedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Selección de materia requerida"),
        content: const Text("Por favor seleccione una materia antes de añadir un estudiante."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Ok"),
          ),
        ],
      );
    },
  );
}
