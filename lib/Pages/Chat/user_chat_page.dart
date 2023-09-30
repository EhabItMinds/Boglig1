// ignore_for_file: use_key_in_widget_constructors, prefer_interpolation_to_compose_strings
import 'package:bolig/Pages/Chat/chate_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({Key? key});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  final user = FirebaseAuth.instance.currentUser!;

  //create a user list
  final FirebaseAuth auth = FirebaseAuth.instance;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build ind user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all but not the curren user
    if (auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatePage(
                receiverUserEmail: data['email'],
                resiveruserid: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
