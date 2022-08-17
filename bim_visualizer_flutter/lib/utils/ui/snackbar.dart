import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// class that implements a global snackbar alert
class CustomSnackbar {
  final BuildContext context;
  final String title;
  final String message;
  final bool error;

  late Flushbar flush;

  CustomSnackbar({ required this.context, required this.title, required this.message, this.error = false }) {
    flush = Flushbar<void>(
      maxWidth: MediaQuery.of(context).size.width / 2,
      backgroundColor: error ? errorColor : successColor,
      title: title,
      isDismissible: true,
      titleSize: 20.0,
      message: message,
      messageSize: 16.0,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      mainButton: IconButton(
        icon: const Icon(Icons.close, color: primaryColor),
        onPressed: () {
          flush.dismiss(true);
        },
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 100.0),
      borderRadius: BorderRadius.circular(8.0),
    )..show(context);
  }
}