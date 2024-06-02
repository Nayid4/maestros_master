import 'package:flutter/material.dart';

class RegisterTop extends StatelessWidget {
  const RegisterTop({Key? key, required this.mediaSize}) : super(key: key);

  final Size mediaSize;

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
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
