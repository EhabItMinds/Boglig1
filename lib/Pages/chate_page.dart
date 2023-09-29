import 'package:bolig/Pages/message_list.dart';
import 'package:bolig/components/chat_bubble.dart';
import 'package:bolig/components/message_input.dart';
import 'package:bolig/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_2_icon/string_2_icon.dart';

class ChatePage extends StatefulWidget {
  final String receiverUserEmail;
  final String resiveruserid;
  const ChatePage(
      {super.key,
      required this.receiverUserEmail,
      required this.resiveruserid});

  @override
  State<ChatePage> createState() => _ChatePageState();
}

class _ChatePageState extends State<ChatePage> {
  final TextEditingController messageController = TextEditingController();
  final ChateService chateservice = ChateService();
  final FirebaseAuth firebaseauth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chateservice.sendMessage(
          widget.resiveruserid, messageController.text);
      //clear the controller after sending the message
      messageController.clear();
    } else {
      await chateservice.sendMessage(
          widget.resiveruserid,
          Icon(
            String2Icon.getIconDataFromString('thumb_up'),
            color: Colors.blue,
          ).toString());
      //clear the controller after sending the message
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          //messages
          Expanded(
            child: MessageList(
              chateService: chateservice,
              receiverUserEmail: widget.receiverUserEmail,
              resiveruserid: widget.resiveruserid,
              firebaseauth: firebaseauth,
            ),
          ),
          //user input
          MessageInputWidget(
            messageController: messageController,
            sendMessage: sendMessage,
          ),
          const SizedBox(
            height: 25,
          ),
        ]),
      ),
    );
  }
}
