import 'package:flutter/material.dart';

class Textos extends StatelessWidget {
  const Textos({super.key, required this.controlador, required this.titulo});

  final TextEditingController controlador;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      decoration: InputDecoration(
        filled: true,
        labelText: titulo,
        suffix: GestureDetector(
          child: const Icon(Icons.close),
          onTap: () {
            controlador.clear();
          },
        ),
      ),
    );
  }
}
