import 'package:flutter/material.dart';

Widget buildIconButtonAddDay(BuildContext context, Function showAddDayDialog) {
  return IconButton(
    onPressed: () {
      showAddDayDialog(context);
    },
    icon: const Icon(Icons.add_circle_outline),
  );
}
