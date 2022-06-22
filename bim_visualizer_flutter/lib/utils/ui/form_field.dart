import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

// class that implements a global form field widget
class CustomFormField {
  static Widget build({enabled = true,
      obscureText = false,
      fieldController,
      required labelText,
      required textInputType}) {
    return TextFormField(
      controller: fieldController,
      keyboardType: textInputType,
      cursorColor: secondaryColor,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabled: enabled,
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 24.0, color: secondaryColor)
      )
    );
  }
}