import 'package:bolig/components/enter_a_message.dart';
import 'package:flutter/material.dart';

class MessageInputWidget extends StatefulWidget {
  final TextEditingController messageController;
  final Function sendMessage;

  MessageInputWidget({
    required this.messageController,
    required this.sendMessage,
  });

  @override
  _MessageInputWidgetState createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Expanded(
            child: EnterAmessageTextFiled(
              controller: widget.messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: () {
              if (widget.messageController.text.isNotEmpty) {
                widget.sendMessage();
                widget.messageController.clear();
              }
            },
            icon: Icon(
              Icons.send,
              size: 30,
              color: widget.messageController.text.isNotEmpty
                  ? Colors.green
                  : Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
