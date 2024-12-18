import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pks/components/auth_service.dart';

import 'chat_page.dart';



class ChatList extends StatefulWidget{
  const ChatList({super.key});
  @override
  State<ChatList> createState() => _ChatListState();

}

class _ChatListState  extends State<ChatList>{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Чатики'),
      ),
      body:  _buildUserList(),
    );
  }
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot){
      if (snapshot.hasError){
        return const Text('Тренеруйся');
      }

      if (snapshot.connectionState == ConnectionState.waiting){
        return const Text('Крутимся');
      }
      return ListView(
        children: snapshot.data!.docs
            .map<Widget>((doc)=>_buildUserListItem(doc))
            .toList(),
      );
        },
    );
  }
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']){
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
            context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: data['email'],
              receiverUserID: data['uid'],
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