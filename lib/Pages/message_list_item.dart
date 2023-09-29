import 'package:bolig/components/chat_bubble.dart';
import 'package:bolig/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageListItem extends StatefulWidget {
  final String receiverUserEmail;
  final String resiveruserid;
  final ChateService chateService;
  final FirebaseAuth firebaseauth;
  final List<QueryDocumentSnapshot<Object?>> documents;

  const MessageListItem({
    super.key,
    required this.receiverUserEmail,
    required this.resiveruserid,
    required this.chateService,
    required this.firebaseauth,
    required this.documents,
  });

  @override
  State<MessageListItem> createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
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
        alignment: (data['senderId'] == widget.firebaseauth.currentUser!.uid)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment:
                (data['senderId'] == widget.firebaseauth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == widget.firebaseauth.currentUser!.uid)
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
        alignment: (data['senderId'] == widget.firebaseauth.currentUser!.uid)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment:
                (data['senderId'] == widget.firebaseauth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == widget.firebaseauth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              // Text(data['senderEmail']),
              const SizedBox(height: 5),
              (data['senderId'] == widget.firebaseauth.currentUser!.uid)
                  ? ChateBubbleSender(message: messageText)
                  : ChatebubbleResiver(message: messageText)
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      children: widget.documents
          .map((document) => buildMessageItem(document))
          .toList(),
    );
  }
}
