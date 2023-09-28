import 'dart:ffi';

import 'package:bolig/components/chat_bubble.dart';
import 'package:bolig/components/enter_a_message.dart';
import 'package:bolig/components/message_input.dart';
import 'package:bolig/components/mytextfield.dart';
import 'package:bolig/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    //align the messagees to the right if the sender is the current user, other WISE TO THE LEFT
    var aligment = (data['senderId'] == firebaseauth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: aligment,
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
              const SizedBox(
                height: 5,
              ),
              (data['receiverId'] == firebaseauth.currentUser!.uid)
                  ? ChatebubbleResiver(message: data['message'])
                  : ChateBubbleSender(message: data['message'])
            ]),
      ),
    );
  }

  //build message input

  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Expanded(
            child: EnterAmessageTextFiled(
              controller: messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: (messageController.text.isNotEmpty)
                ? const Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.blue,
                  ),
          )
        ],
      ),
    );
  }
}
