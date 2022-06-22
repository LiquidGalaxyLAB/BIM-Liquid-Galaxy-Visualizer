import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// class that implements a global snackbar alert
class CustomSnackbar {
  static show({required BuildContext context, required String title, required String message, bool error = false}) {
    Flushbar(
      backgroundColor: error ? errorColor : successColor,
      title: title,
      isDismissible: true,
      flushbarStyle: FlushbarStyle.GROUNDED,
      titleSize: 20.0,
      message: message,
      messageSize: 16.0,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP
    ).show(context);
  }
}