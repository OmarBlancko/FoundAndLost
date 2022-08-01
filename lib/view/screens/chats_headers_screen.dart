import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/main.dart';
import 'package:found_and_lost/model/user.dart';
import 'package:found_and_lost/view/widgets/chat_head.dart';
import 'package:provider/provider.dart';

class ChatsHeadersScreen extends StatefulWidget {
  static const routeName = '/ChatsHeadersScreen';

  @override
  State<ChatsHeadersScreen> createState() => _ChatsHeadersScreenState();
}

class _ChatsHeadersScreenState extends State<ChatsHeadersScreen> {
  late List<AuthenticatedUser> usersHaveMessages = [];
  var _isLoading = false;
  _getUsersChats() async {
    setState(() {
      _isLoading = true;
    });
    late List<dynamic> sentMessages = []; // get messages sent by current user
    late List<dynamic> receivedMessages = []; // get messages received by current user
    late List<String> receiverIds = [];
    await FirebaseFirestore.instance
        .collection('chat').where('senderId', isEqualTo: globalUserIdentification)
        .get()
        .then((value) {
      sentMessages = value.docs.toList();
    });

    await FirebaseFirestore.instance
        .collection('chat').where('receiverId', isEqualTo: globalUserIdentification)
        .get()
        .then((value) {
      receivedMessages = value.docs.toList();
    });

    for (var msg in sentMessages) {
      if (!receiverIds.contains(msg['receiverId'])) {
        receiverIds.add(msg['receiverId']);
      }
    }

    for (var msg in receivedMessages) {
      if (!receiverIds.contains(msg['senderId'])) {
        receiverIds.add(msg['senderId']);
      }
    }
    for (var receiverId in receiverIds) {
      var authenticatedUser =
          await Provider.of<UserDataController>(context, listen: false)
              .getUserDataById(receiverId);
      usersHaveMessages.add(authenticatedUser!);
    }
    // for (var i in usersHaveMessages) {
    //   print(i.imageUrl);
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _getUsersChats();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatsHeadersScreen oldWidget) {
    if (kDebugMode) {
      print(usersHaveMessages.length);
    }
    if (usersHaveMessages.isEmpty) {
      _getUsersChats();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My chats',
          style: TextStyle(
            fontSize: size.setWidth(18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitThreeInOut(
                color: Colors.blueGrey,
              ),
            )
          : Container(
              height: size.setHeight(800),
              width: double.infinity,
              child: ListView.builder(
                itemCount: usersHaveMessages.length,
                itemBuilder: (context, index) => ChatHead(
                   userId: usersHaveMessages[index].id,
                    userName:usersHaveMessages[index].name,
                    userImageUrl:usersHaveMessages[index].imageUrl),
              ),
            ),
    );
  }
}
