import 'package:flutter/material.dart';

Widget buildDropDownButton(String selectedDay, Function(String) onChanged) {
  final List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];

  return DropdownButton<String>(
    value: selectedDay,
    onChanged: (String? newValue) {
      if (newValue != null) {
        onChanged(newValue);
      }
    },
    items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}
