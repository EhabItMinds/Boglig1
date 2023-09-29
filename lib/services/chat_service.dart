import 'package:bolig/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_2_icon/string_2_icon.dart';

class ChateService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
//get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currenUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newmessage = Message(
        senderId: currentUserId,
        senderEmail: currenUserEmail,
        receiverId: receiverId,
        message: message,
        timstamp: timestamp);

    //construct a chat room id from current user ud and receiver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for any pair of peolpe)
    String chaRommsId = ids
        .join("_"); // combine the ids into a single string to use as a chatroom

    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chaRommsId)
        .collection('messages')
        .add(newmessage.toMap());
  }

  //get message

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct a chat room id from current user ud and receiver id
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for any pair of peolpe)
    String chaRommsId = ids
        .join("_"); // combine the ids into a single string to use as a chatroom

    return _firestore
        .collection('chat_rooms')
        .doc(chaRommsId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<List<dynamic>> getMessages1(String userId, String otherUserId) {
    // Construct a chat room id from the current user id and receiver id
    List<String> ids = [userId, otherUserId];
    ids.sort(); // Sort the ids (this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids
        .join("_"); // Combine the ids into a single string to use as a chatroom

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      // Map the snapshot documents to messages
      return snapshot.docs.map((QueryDocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String messageText = data['message'];

        // Check if the message starts with an icon indicator
        if (messageText.startsWith("[ICON]")) {
          // Extract the icon identifier (e.g., "[ICON]star")
          String iconString = messageText.substring(6); // Remove "[ICON]"

          // Create an Icon widget
          Icon icon = Icon(String2Icon.getIconDataFromString(iconString));

          // Replace the message text with the Icon widget
          data['message'] = icon;
        }

        return data;
      }).toList();
    });
  }
}
