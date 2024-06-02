import 'package:flutter/material.dart';

class LoginTop extends StatelessWidget {
  final Size mediaSize;

  const LoginTop({Key? key, required this.mediaSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
