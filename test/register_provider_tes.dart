import 'package:flutter_test/flutter_test.dart';

class Usuario {
  final String correo;
  final String contrasena;

  Usuario({required this.correo, required this.contrasena});
}

void main() {
  test('Crear una instancia de registro con valores válidos', () {
    final usuario =
        Usuario(correo: 'luisca@gmail.com', contrasena: "luisca12345");

    expect(usuario.correo, 'luisca@gmail.com');
    expect(usuario.contrasena, "luisca12345");
  });
}
