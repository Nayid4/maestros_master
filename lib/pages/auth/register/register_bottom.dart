import 'package:flutter/material.dart';
import 'register_form.dart';

class RegisterBottom extends StatelessWidget {
  const RegisterBottom({Key? key, required this.mediaSize, required this.mycolor}) : super(key: key);

  final Size mediaSize;
  final Color mycolor;

  @override
  Widget build(BuildContext context) {
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
          child: RegisterForm(mycolor: mycolor),
        ),
      ),
    );
  }
}
