import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maestros_master/provider/login_provider.dart';

class LoginInputField extends StatelessWidget {
  final TextEditingController textcontroller;
  final bool isPassword;

  const LoginInputField({Key? key, required this.textcontroller, this.isPassword = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textcontroller,
      obscureText: isPassword && Provider.of<LoginProvider>(context).isObscured,
      decoration: InputDecoration(
        hintText: isPassword ? 'Contraseña' : 'Correo electrónico',
        suffixIcon: !isPassword
            ? const Icon(Icons.email)
            : IconButton(
                onPressed: () {
                  Provider.of<LoginProvider>(context, listen: false).toggleObscured();
                },
                icon: Icon(
                  Provider.of<LoginProvider>(context).isObscured
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
        suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
