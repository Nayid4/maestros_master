import 'package:flutter/material.dart';
import 'login_input_field.dart';
import 'login_bottom_action.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailText;
  final TextEditingController passText;

  const LoginForm({Key? key, required this.emailText, required this.passText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // GlobalKey para el formulario
    Color mycolor = const Color.fromRGBO(0, 191, 99, 1);

    return Form(
      key: _formKey, // Asignar el GlobalKey al formulario
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Bienvenido",
            style: TextStyle(
                color: mycolor, fontSize: 32, fontWeight: FontWeight.w500),
          ),
          _buildTextGray("Ingrese sus credenciales"),
          const SizedBox(height: 50),
          _buildTextGray("Correo electrónico"),
          TextFormField(
            controller: emailText,
            decoration: const InputDecoration(hintText: 'Correo electrónico'),
            validator: validateEmail,
          ),
          const SizedBox(height: 40),
          _buildTextGray("Contraseña"),
          TextFormField(
            controller: passText,
            decoration: const InputDecoration(hintText: 'Contraseña'),
            obscureText: true,
            validator: validatePassword,
          ),
          const SizedBox(height: 40),
          LoginBottomAction(
            titulo: "Iniciar sesión",
            emailText: emailText,
            passText: passText,
            formKey: _formKey, // Pasar el GlobalKey al LoginBottomAction
          ),
          const SizedBox(height: 20),
          LoginBottomAction(
            titulo: "Registrarse",
            emailText: emailText,
            passText: passText,
            formKey: null, // No se valida el formulario para el botón de registro
          )
        ],
      ),
    );
  }

  Widget _buildTextGray(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }
}

// Funciones de validación de correo electrónico y contraseña
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) return 'El correo es obligatorio';
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) return 'Formato de correo incorrecto';
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) return 'La contraseña es obligatoria';
  if (password.length < 10) return 'La contraseña debe tener al menos 10 caracteres';
  if (password.length > 20) return 'La contraseña no debe exceder los 20 caracteres';
  return null;
}
