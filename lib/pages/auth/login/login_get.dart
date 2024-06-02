import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:maestros_master/provider/login_provider.dart';

class LoginGet extends StatelessWidget {
  const LoginGet({Key? key});

  static Color mycolor = const Color.fromRGBO(0, 191, 99, 1);
  static late Size mediaSize;
  static TextEditingController emailText = TextEditingController();
  static TextEditingController passText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: mycolor,
        image: DecorationImage(
          image: const AssetImage("assets/cover.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(mycolor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 50, child: _buildTop()),
            Positioned(bottom: 0, child: _buildBottom(context))
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "MAESTROS",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
  return SizedBox(
    width: mediaSize.width,
    child: Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _buildForm(context), // Pasa el contexto aquí
      ),
    ),
  );
}


  Widget _buildForm(BuildContext context) {
  return Column(
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
      _buildInputField(context, emailText),
      const SizedBox(height: 40),
      _buildTextGray("Contraseña"),
      _buildInputField(context, passText, isPassword: true),
      const SizedBox(height: 40),
      _buildBottomAction(context, "Iniciar sesión"),
      const SizedBox(height: 20),
      _buildBottomAction(context, "Registrarse")
    ],
  );
}

  Widget _buildTextGray(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(BuildContext context, TextEditingController textcontroller,
      {bool isPassword = false}) {
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
          )
        ],
      ),
      child: TextButton(
        onPressed: () {
          if (titulo == "Iniciar sesión") {
            final loginProvider = Provider.of<LoginProvider>(context, listen: false);
            loginProvider.loginUser(
              correo: emailText.text,
              password: passText.text,
              onSuccess: () {
                // Aquí imprime la información del usuario al iniciar sesión
                //print('Usuario actual: ${loginProvider.currentUser}');
                print('Información del usuario: ${loginProvider.userInfo}');
                Get.toNamed("/home");
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
          if (titulo == "Registrarse") {
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
