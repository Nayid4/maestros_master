import 'package:flutter/material.dart';
import 'register_top.dart';
import 'register_bottom.dart';

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
            Positioned(top: 50, child: RegisterTop(mediaSize: mediaSize)),
            Positioned(bottom: 0, child: RegisterBottom(mediaSize: mediaSize, mycolor: mycolor)),
          ],
        ),
      ),
    );
  }
}
