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
            child: _buildNessageList(),
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

  //build message list
  Widget _buildNessageList() {
    return StreamBuilder(
      stream: chateservice.getMessages(
          widget.resiveruserid, firebaseauth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
  //build message item

  Widget buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    String messageText = data['message'];

    // Check if the message starts with an icon indicator
    if (messageText.startsWith("Icon")) {
      // Create an Icon widget
      Icon icon = const Icon(
        IconData(0xe65b, fontFamily: 'MaterialIcons'),
        color: Colors.blue,
        size: 40,
      );

      // Return the Icon widget
      return Container(
        alignment: (data['senderId'] == firebaseauth.currentUser!.uid)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment:
                (data['senderId'] == firebaseauth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == firebaseauth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              // Text(data['senderEmail']),
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon, // Display the Icon
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // Regular text message
      return Container(
        alignment: (data['senderId'] == firebaseauth.currentUser!.uid)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment:
                (data['senderId'] == firebaseauth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == firebaseauth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              // Text(data['senderEmail']),
              const SizedBox(height: 5),
              (data['senderId'] == firebaseauth.currentUser!.uid)
                  ? ChateBubbleSender(message: messageText)
                  : ChatebubbleResiver(message: messageText)
            ],
          ),
        ),
      );
    }
  }
}
