import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:found_and_lost/main.dart';

class NewMessages extends StatefulWidget {

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {

  var _enteredMessage = '';
  final _controller = new TextEditingController();
  void _sendMessage() async{
    _controller.clear();
    FocusScope.of(context).unfocus();
    final user =  FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    await FirebaseFirestore.instance.collection('chat').add({
      'text':_enteredMessage,
      'createdAt':Timestamp.now(),
      'senderId':user.uid,
      'receiverId':globalChatReceiverId,
      'username':userData['userName'],
      'userImage':userData['imageUrl']
    });
    // print(user.uid);
    _enteredMessage='';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Send Message',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage=value;
                });
              },
            ),
          ),
           IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send),
              color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
