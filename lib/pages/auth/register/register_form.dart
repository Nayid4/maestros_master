import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maestros_master/provider/register_provider.dart';
import 'register_get.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key, required this.mycolor}) : super(key: key);

  final Color mycolor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Bienvenido",
          style: TextStyle(
            color: mycolor,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildTextGray("Ingrese sus credenciales"),
        const SizedBox(height: 50),
        _buildTextGray("Correo electrónico"),
        _buildInputField(context, RegisterGet.emailText, isEmail: true),
        const SizedBox(height: 40),
        _buildTextGray("Contraseña"),
        _buildInputField(context, RegisterGet.passText, isPassword: true),
        const SizedBox(height: 40),
        _buildTextGray("Confirmar contraseña"),
        _buildInputField(context, RegisterGet.passTextConfirm, isPassword: true),
        const SizedBox(height: 40),
        _buildBottomAction(context, "Guardar"),
        const SizedBox(height: 20),
        _buildBottomAction(context, "Cancelar"),
      ],
    );
  }

  Widget _buildTextGray(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(BuildContext context, TextEditingController textcontroller, {bool isPassword = false, bool isEmail = false}) {
    final _focusNode = FocusNode();
    bool _isTouched = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Focus(
          focusNode: _focusNode,
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _isTouched = true;
            }
            setState(() {});
          },
          child: TextField(
            controller: textcontroller,
            obscureText: isPassword && Provider.of<RegisterProvider>(context).isObscured,
            decoration: InputDecoration(
              suffixIcon: !isPassword
                  ? const Icon(Icons.email)
                  : IconButton(
                      onPressed: () {
                        Provider.of<RegisterProvider>(context, listen: false).toggleObscured();
                      },
                      icon: Icon(
                        Provider.of<RegisterProvider>(context).isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
              suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              hintText: isPassword ? 'Contraseña' : 'Correo electrónico',
              errorText: _isTouched ? _getErrorText(textcontroller.text, isPassword: isPassword, isEmail: isEmail) : null,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        );
      },
    );
  }

  String? _getErrorText(String text, {bool isPassword = false, bool isEmail = false}) {
    if (isPassword) {
      if (text.isEmpty) return 'La contraseña es obligatoria';
      if (text.length < 6) return 'La contraseña debe tener al menos 10 caracteres';
      if (text.length > 20) return 'La contraseña no debe exceder los 20 caracteres';
    } else if (isEmail) {
      if (text.isEmpty) return 'El correo es obligatorio';
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(text)) return 'El correo no es válido';
    }
    return null;
  }

  Widget _buildBottomAction(BuildContext context, String titulo) {
    return Center(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: mycolor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(3, 3),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            if (titulo == "Guardar") {
              final emailError = _getErrorText(RegisterGet.emailText.text, isEmail: true);
              final passError = _getErrorText(RegisterGet.passText.text, isPassword: true);
              final confirmPassError = _getErrorText(RegisterGet.passTextConfirm.text, isPassword: true);

              if (emailError == null && passError == null && confirmPassError == null) {
                if (_comprobar(RegisterGet.passText.text, RegisterGet.passTextConfirm.text)) {
                  Provider.of<RegisterProvider>(context, listen: false).registerUser(
                    email: RegisterGet.emailText.text,
                    password: RegisterGet.passText.text,
                    token: '', // Puedes pasar un token si lo necesitas
                    createdAt: DateTime.now(),
                    onError: (String error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Registro exitoso"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      _clearFields();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Las contraseñas no coinciden"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(emailError ?? passError ?? confirmPassError ?? "Error desconocido"),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
            if (titulo == "Cancelar") {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    RegisterGet.emailText.clear();
    RegisterGet.passText.clear();
    RegisterGet.passTextConfirm.clear();
  }

  bool _comprobar(String pass1, String pass2) {
    return pass1 == pass2;
  }
}
