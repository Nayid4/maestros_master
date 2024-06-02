import 'package:flutter/material.dart';
import 'login_top.dart';
import 'login_bottom.dart';

class LoginGet extends StatelessWidget {
  const LoginGet({super.key});

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
            Positioned(top: 50, child: LoginTop(mediaSize: mediaSize)),
            Positioned(bottom: 0, child: LoginBottom(mediaSize: mediaSize, emailText: emailText, passText: passText))
          ],
        ),
      ),
    );
  }
}
