import 'package:flutter/material.dart';
import 'login_form.dart';

class LoginBottom extends StatelessWidget {
  final Size mediaSize;
  final TextEditingController emailText;
  final TextEditingController passText;

  const LoginBottom({Key? key, required this.mediaSize, required this.emailText, required this.passText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: LoginForm(emailText: emailText, passText: passText),
        ),
      ),
    );
  }
}
