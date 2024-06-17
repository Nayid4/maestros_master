import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maestros_master/provider/login_provider.dart';

class LoginInputField extends StatefulWidget {
  final TextEditingController textcontroller;
  final bool isPassword;

  const LoginInputField({Key? key, required this.textcontroller, this.isPassword = false}) : super(key: key);

  @override
  _LoginInputFieldState createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField> {
  bool _isTouched = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() {
            _isTouched = true;
          });
        }
      },
      child: TextField(
        controller: widget.textcontroller,
        obscureText: widget.isPassword && Provider.of<LoginProvider>(context).isObscured,
        decoration: InputDecoration(
          hintText: widget.isPassword ? 'Contraseña' : 'Correo electrónico',
          errorText: _isTouched ? _getErrorText(widget.textcontroller.text, isPassword: widget.isPassword) : null,
          suffixIcon: !widget.isPassword
              ? const Icon(Icons.email)
              : IconButton(
                  onPressed: () {
                    Provider.of<LoginProvider>(context, listen: false).toggleObscured();
                  },
                  icon: Icon(
                    Provider.of<LoginProvider>(context).isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
          suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  String? _getErrorText(String text, {bool isPassword = false}) {
    if (isPassword) {
      if (text.isEmpty) return 'La contraseña es obligatoria';
      if (text.length < 6) return 'La contraseña debe tener al menos 10 caracteres';
      if (text.length > 20) return 'La contraseña no debe exceder los 20 caracteres';
    } else {
      if (text.isEmpty) return 'El correo es obligatorio';
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(text)) return 'El correo no es válido';
    }
    return null;
  }
}
