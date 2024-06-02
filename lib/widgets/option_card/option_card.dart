
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String route;
  final Color color;

  const OptionCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.route,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Card(
        color: color.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
