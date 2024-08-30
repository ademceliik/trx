import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  final Color? color;
  final String contentText;
  CustomSnackBar(
      {super.key, required this.contentText, this.color = Colors.green})
      : super(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          content: Text(contentText, textAlign: TextAlign.center),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        );
}
