import 'package:flutter/material.dart';

showToast({BuildContext? context, Color? color}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    backgroundColor: color,
    content: const Text(
      "Add product success",
      style: TextStyle(color: Colors.white),
    ),
    duration: const Duration(seconds: 2),
  ));
}

showToast1({BuildContext? context, Color? color, String? content}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    backgroundColor: color,
    content: Text(
      content!,
      style: const TextStyle(color: Colors.white),
    ),
    duration: const Duration(seconds: 2),
  ));
}
