import 'package:flutter/material.dart';

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg), // This was causing the error
    duration: const Duration(seconds: 1),
  ));
}
