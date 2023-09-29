import 'package:flutter/material.dart';

class EnterAmessageTextFiled extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(String) onChanged;

  const EnterAmessageTextFiled({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<EnterAmessageTextFiled> createState() => _EnterAmessageTextFiledState();
}

class _EnterAmessageTextFiledState extends State<EnterAmessageTextFiled> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(25.0), // Adjust the radius as needed
        color: Colors.grey.shade200,
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
