import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'login_get.dart';

class LoginBottomAction extends StatelessWidget {
  final String titulo;
  final TextEditingController emailText;
  final TextEditingController passText;
  final GlobalKey<FormState>? formKey;

  const LoginBottomAction({
    Key? key,
    required this.titulo,
    required this.emailText,
    required this.passText,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: LoginGet.mycolor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(3, 3),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
        ),
        child: TextButton(
          onPressed: () {
            if (titulo == "Iniciar sesión") {
              if (formKey != null && formKey!.currentState!.validate()) {
                final loginProvider = Provider.of<LoginProvider>(context, listen: false);
                loginProvider.loginUser(
                  correo: emailText.text,
                  password: passText.text,
                  onSuccess: () {
                    // Redirigir a la página de inicio después de iniciar sesión
                    Get.offNamed("/home");
                    // Limpiar campos de texto
                    emailText.clear();
                    passText.clear();
                  },
                  onError: (String error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                );
              }
            } else if (titulo == "Registrarse") {
              Get.toNamed("/registrarse");
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
}
