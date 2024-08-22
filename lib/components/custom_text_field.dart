import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.onChanged,
    this.isObscure = false,
    this.suffix,
    this.controller,
  });

  final String hintText;
  final IconData icon;
  final bool isObscure;
  final Widget? suffix;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade200),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: isObscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            border: InputBorder.none,
            suffixIcon: suffix,
            hintText: hintText,
          ),
        ));
  }
}
