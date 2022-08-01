import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/main.dart';

import 'package:chat_bubbles/chat_bubbles.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          // snapshot without null mark to get access to docs property
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = chatSnapshot.data!.docs;
          final FirebaseAuth auth = FirebaseAuth.instance;
          late final User? user;
          user = auth.currentUser;
          return ListView.builder(
              padding: EdgeInsets.only(left: 5),
              reverse: true,
              shrinkWrap: true,
              // this causes rendering error RenderBox was not laid out
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) =>
              // conditions to get chat messages between 2 persons only
                  ((chatDocs[index]['senderId'] == user!.uid &&  chatDocs[index]['receiverId'] == globalChatReceiverId)
                      ||
                          (chatDocs[index]['receiverId'] == user.uid && chatDocs[index]['senderId'] == globalChatReceiverId))
                      ?  chatDocs[index]['senderId'] == user.uid ? // is me ?
                  BubbleSpecialThree(text:chatDocs[index]['text'] ,
                    color: Colors.grey.shade300,
                    isSender: true,
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: size.setWidth(16)
                    ),)
                      : BubbleSpecialThree(text:chatDocs[index]['text'] ,
                    color: Colors.black87,
                    isSender: false,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: size.setWidth(16)
                    ),)

                    : const SizedBox(
                          height: 0,
                          width: 0,
                        ));
        });
  }
}
/*
MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]['senderId'] == user.uid,
                          chatDocs[index]['username'],
                          chatDocs[index]['userImage'],
                          key: ValueKey(chatDocs[index].id),
                        )
 */
 /*
 chatDocs[index]['senderId'] == user.uid ? // is me ?
                  BubbleSpecialThree(text:chatDocs[index]['text'] ,
                  color: Colors.grey.shade300,
                  isSender: true,
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: size.setWidth(16)
                  ),)
                      : BubbleSpecialThree(text:chatDocs[index]['text'] ,
                    color: Colors.black87,
                    isSender: false,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: size.setWidth(16)
                    ),)
  */