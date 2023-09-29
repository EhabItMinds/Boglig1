import 'package:bolig/components/enter_a_message.dart';
import 'package:flutter/material.dart';

class MessageInputWidget extends StatefulWidget {
  final TextEditingController messageController;
  final Function sendMessage;

  const MessageInputWidget({
    super.key,
    required this.messageController,
    required this.sendMessage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MessageInputWidgetState createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  bool isTextNotEmpty = false;

  @override
  void initState() {
    super.initState();
    // Initialize isTextNotEmpty based on the initial text in the controller
    isTextNotEmpty = widget.messageController.text.isNotEmpty;
  }

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
              onChanged: (text) {
                setState(() {
                  isTextNotEmpty = text.isNotEmpty;
                });
              },
            ),
          ),
          IconButton(
              onPressed: () {
                widget.sendMessage();

                if (isTextNotEmpty) {
                  setState(() {
                    isTextNotEmpty = false;
                  });
                }
              },
              icon: isTextNotEmpty
                  ? const Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.thumb_up,
                      size: 30,
                      color: Colors.blue,
                    ))
        ],
      ),
    );
  }
}
