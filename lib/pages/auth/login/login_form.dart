import 'package:flutter/material.dart';
import 'login_input_field.dart';
import 'login_bottom_action.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailText;
  final TextEditingController passText;

  const LoginForm({Key? key, required this.emailText, required this.passText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color mycolor = const Color.fromRGBO(0, 191, 99, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Bienvenido",
          style: TextStyle(color: mycolor, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildTextGray("Ingrese sus credenciales"),
        const SizedBox(height: 50),
        _buildTextGray("Correo electrónico"),
        LoginInputField(textcontroller: emailText),
        const SizedBox(height: 40),
        _buildTextGray("Contraseña"),
        LoginInputField(textcontroller: passText, isPassword: true),
        const SizedBox(height: 40),
        LoginBottomAction(titulo: "Iniciar sesión", emailText: emailText, passText: passText),
        const SizedBox(height: 20),
        LoginBottomAction(titulo: "Registrarse", emailText: emailText, passText: passText)
      ],
    );
  }

  Widget _buildTextGray(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }
}
