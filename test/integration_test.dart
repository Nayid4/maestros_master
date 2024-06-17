import 'package:flutter_test/flutter_test.dart';

class Usuario {
  final String correo;
  final String contrasena;

  Usuario({required this.correo, required this.contrasena});
}

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
  test('Crear instancias con valores válidos', () {
    // Test de registro de usuario
    final usuarioRegistro =
        Usuario(correo: 'luisca@gmail.com', contrasena: "luisca12345");
    expect(usuarioRegistro.correo, 'luisca@gmail.com');
    expect(usuarioRegistro.contrasena, "luisca12345");

    // Test de inicio de sesión de usuario
    final usuarioLogin =
        Usuario(correo: 'luisca@gmail.com', contrasena: "luisca12345");
    expect(usuarioLogin.correo, 'luisca@gmail.com');
    expect(usuarioLogin.contrasena, "luisca12345");

    // Test de registro de estudiante
    final estudiante = Estudiante(
        nombre: "Luis Andres",
        apellido: "Cataño Cataño",
        identificacion: 1003123456);
    expect(estudiante.nombre, 'Luis Andres');
    expect(estudiante.apellido, "Cataño Cataño");
    expect(estudiante.identificacion, 1003123456);
  });
}
