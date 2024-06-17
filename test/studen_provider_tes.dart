import 'package:flutter_test/flutter_test.dart';

class Estudiante {
  final String nombre;
  final String apellido;
  final int identificacion;

  Estudiante(
      {required this.nombre,
      required this.apellido,
      required this.identificacion});
}

void main() {
  test("Crear una instancia de registro de estudiante con valores válidos", () {
    final estudiante = Estudiante(
        nombre: "Luis Andres",
        apellido: "Cataño Cataño",
        identificacion: 1003123456);

    expect(estudiante.nombre, 'Luis Andres');
    expect(estudiante.apellido, "Cataño Cataño");
    expect(estudiante.identificacion, 1003123456);
  });
}
