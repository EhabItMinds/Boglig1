import 'package:flutter/material.dart';

class SqureTile extends StatelessWidget {
  final String imagePth;
  final Function()? onTap;
  const SqureTile({super.key, required this.imagePth, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePth,
          height: 40,
        ),
      ),
    );
  }
}
