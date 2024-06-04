import 'package:flutter/material.dart';

Widget buildTextField({required TextEditingController controller, required String labelText}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
    ),
  );
}
