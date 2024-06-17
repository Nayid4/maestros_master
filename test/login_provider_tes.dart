import 'package:flutter_test/flutter_test.dart';

class Usuario {
  final String correo;
  final String contrasena;

  Usuario({required this.correo, required this.contrasena});
}

void main() {
  test('Crear una instancia de inicio de sesión con valores válidos', () {
    final usuario =
        Usuario(correo: 'docente@gmail.com', contrasena: "Docente12345");

    expect(usuario.correo, 'docente@gmail.com');
    expect(usuario.contrasena, "Docente12345");
  });
}
