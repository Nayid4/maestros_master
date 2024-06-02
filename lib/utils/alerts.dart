import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alerts {
  List<Icon> iconos = [
    const Icon(Icons.dangerous),
    const Icon(
      Icons.verified,
      color: Colors.red,
    )
  ];

  void showAlerts(
      {required String title, required String message, required bool isError}) {
    Get.snackbar(title, message,
        duration: const Duration(seconds: 3), icon: isError ? iconos[0] : iconos[1]);
  }
}
