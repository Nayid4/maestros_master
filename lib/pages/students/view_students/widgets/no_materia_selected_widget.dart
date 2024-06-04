import 'package:flutter/material.dart';

class NoMateriaSelectedWidget extends StatelessWidget {
  const NoMateriaSelectedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0.3 * MediaQuery.of(context).size.height,
        ),
        const ListTile(
          title: Text(
            "No se ha seleccionado una materia",
            style: TextStyle(color: Colors.black26, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
