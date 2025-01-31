import 'package:flutter/material.dart';

Widget buildStylizedButton({
  required VoidCallback? onPressed,
  required String text,
  bool isPrimary = true,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF2196F3) : Colors.white,
        foregroundColor: isPrimary ? Colors.white : const Color(0xFF2196F3),
        elevation: isPrimary ? 3 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: isPrimary ? Colors.transparent : const Color(0xFF2196F3),
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isPrimary ? Colors.white : const Color(0xFF2196F3),
        ),
      ),
    ),
  );
}
