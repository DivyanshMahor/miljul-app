import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

enum SnackbarType { success, error }

void showAppSnackbar({
  required BuildContext context,
  required SnackbarType type,
  required String description,
}) {
  switch (type) {

    case SnackbarType.success:
      CherryToast.success(
        toastPosition: Position.top,
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        backgroundColor: Colors.green.withAlpha(40),

        description: Text(
          description,
          style: const TextStyle(
            color: Colors.green,
          ),
        ),

        title: const Text(
          "Successful",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).show(context);

      break;

    case SnackbarType.error:
      CherryToast.error(
        toastDuration: const Duration(milliseconds: 2000),
        toastPosition: Position.top,
        displayCloseButton: false,
        backgroundColor: Colors.red.withAlpha(40),

        description: Text(
          description,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),

        title: const Text(
          "Error",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).show(context);

      break;
  }
}