import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maestros_master/provider/register_provider.dart';

class RegisterGet extends StatelessWidget {
  const RegisterGet({Key? key}) : super(key: key);

  static Color mycolor = const Color.fromRGBO(0, 191, 99, 1);
  static late Size mediaSize;
  static TextEditingController emailText = TextEditingController();
  static TextEditingController passText = TextEditingController();
  static TextEditingController passTextConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: mycolor,
        image: DecorationImage(
          image: const AssetImage("assets/cover.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(mycolor.withOpacity(0.2), BlendMode.dstATop),
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
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _BuildForm(context),
        ),
      ),
    );
  }

  Widget _BuildForm(BuildContext context) {
    //final registerProvider = Provider.of<RegisterProvider>(context);
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
        _BuildTextGray("Ingrese sus credenciales"),
        const SizedBox(height: 50),
        _BuildTextGray("Correo electrónico"),
        _BuildInputField(context, emailText),
        const SizedBox(height: 40),
        _BuildTextGray("Contraseña"),
        _BuildInputField(context, passText, isPassword: true),
        const SizedBox(height: 40),
        _BuildTextGray("Confirmar contraseña"),
        _BuildInputField(context, passTextConfirm, isPassword: true),
        const SizedBox(height: 40),
        _BuildBottomAction(context, "Guardar"),
        const SizedBox(height: 20),
        _BuildBottomAction(context, "Cancelar"),
      ],
    );
  }

  Widget _BuildTextGray(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

Widget _BuildInputField(BuildContext context, TextEditingController textcontroller,
      {bool isPassword = false}) {
    return TextField(
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
                  Provider.of<RegisterProvider>(context).isObscured
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
        suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        hintText: isPassword ? 'Contraseña' : 'Correo electrónico',
      ),
    );
  }


  Widget _BuildBottomAction(BuildContext context, String titulo) {
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
              if (comprobar(passText.text, passTextConfirm.text)) {
                Provider.of<RegisterProvider>(context, listen: false).registerUser(
                  email: emailText.text,
                  password: passText.text,
                  token: '', // Puedes pasar un token si lo necesitas
                  createdAt: DateTime.now(),
                  onError: (String error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        duration: const Duration(seconds: 3),
                      )
                    );
                  },
                  onSuccess: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Registro exitoso"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    _clearFields(); // Limpiar campos
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
    emailText.clear();
    passText.clear();
    passTextConfirm.clear();
  }

  bool comprobar(String pass1, String pass2) {
    return pass1 == pass2;
  }
}

