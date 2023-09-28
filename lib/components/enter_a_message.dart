import 'package:flutter/material.dart';

class EnterAmessageTextFiled extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const EnterAmessageTextFiled({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
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
        onChanged: (text) {
          setState(() {}); // Rebuild the widget when text changes
        },
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.hintText,
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
