import 'package:bolig/Pages/Chat/message_list_item.dart';
import 'package:bolig/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageList extends StatefulWidget {
  final String receiverUserEmail;
  final String resiveruserid;
  final ChateService chateService;
  final FirebaseAuth firebaseauth;

  const MessageList(
      {super.key,
      required this.chateService,
      required this.receiverUserEmail,
      required this.resiveruserid,
      required this.firebaseauth});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.chateService.getMessages(
          widget.resiveruserid, widget.firebaseauth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        return MessageListItem(
          documents: snapshot.data!.docs,
          receiverUserEmail: widget.receiverUserEmail,
          chateService: widget.chateService,
          firebaseauth: widget.firebaseauth,
          resiveruserid: widget.resiveruserid,
        );
      },
    );
  }
}
