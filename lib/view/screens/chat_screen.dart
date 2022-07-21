import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/main.dart';
import 'package:found_and_lost/model/user.dart';
import 'package:found_and_lost/view/screens/location_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../chats/messages.dart';
import '../chats/new_message.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// define it outside anyclass   +
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  try {
    print("Handling a background message: ${message.messageId}");
  } catch (e) {
    print(e);
  }
}

class ChatScreen extends StatefulWidget {
  static const routeName = '/chatScreen';
  static const apiKey = 'AIzaSyADvZnAmueSwFDpalGUp8lnmDaqNZg8P78'; // for fcm
  late final String receiverId;
  ChatScreen(this.receiverId);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthenticatedUser? user;
  var isLoading = false;
  _handleNotification() async {
    final FirebaseMessaging fbm = FirebaseMessaging.instance;

    NotificationSettings settings = await fbm.requestPermission(
        alert: true,announcement: false,badge: true, carPlay: false,criticalAlert: false,provisional: false, sound: true);
    fbm.subscribeToTopic('chat');
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }

    FirebaseMessaging.onMessage.listen((msg) {
      if (kDebugMode) {
        print(' here\'s message data ${msg.notification?.title}');
      }
    });
    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler); // fbm.setAutoInitEnabled(true);
  }

  @override
  void initState()  {
    _getReceiverInfo();
    _handleNotification();
    super.initState();
  }

  _getReceiverInfo() async {
    if (user == null) {
      print(globalChatReceiverId);
      setState(() {
        isLoading = true;
      });
      user = await Provider.of<UserDataController>(context, listen: false)
          .getUserDataById(widget.receiverId);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    if (user == null) {
      _getReceiverInfo();
      if (kDebugMode) {
        print(globalChatReceiverId);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Scaffold(
      body: Container(
        child: isLoading == true
            ? const Center(
                child: SpinKitPianoWave(
                  color: Colors.blueGrey,
                ),
              )
            : Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: size.setHeight(60),
                    color: Colors.teal,
                    padding: EdgeInsets.only(left: size.setWidth(10)),
                    child: Row(
                      children: <Widget>[
                        const BackButton(),
                        CircleAvatar(
                          backgroundImage: NetworkImage(user!.imageUrl),
                          radius: size.setWidth(22),
                        ),
                        SizedBox(
                          width: size.setWidth(10),
                        ),
                        Container(
                          width: size.setWidth(100),
                          child: Text(
                            user!.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: size.setWidth(14),color: Colors.white),
                          ),
                        ),
                        ElevatedButton(onPressed: () {
                          Navigator.pushNamed(context, LocationScreen.routeName);
                        }, child: Text('Safe meeting point',style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: size.setWidth(14)),
                        ),),
                      ],
                    ),
                  ),
                  Expanded(child: Messages()),
                  NewMessages(),
                ],
              ),
      ),
    );
  }
}
// UserNameAndAvatar(user!.name, user!.imageUrl)
// app bar
// appBar: AppBar(
//   title: Text('Blanc ChatApp'),
//   actions: <Widget>[
//     Padding(
//       padding: EdgeInsets.only(right: 20),
//       child: DropdownButton(
//         icon: Icon(
//           Icons.more_vert,
//           color: Theme.of(context).primaryIconTheme.color,
//         ),
//         items: [
//           DropdownMenuItem(
//             child: Container(
//               child: Row(
//                 children: <Widget>[
//                   Icon(
//                     Icons.exit_to_app,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   SizedBox(
//                     width: 8,
//                   ),
//                   Text('Logout'),
//                 ],
//               ),
//             ),
//             value: 'logout',
//           ),
//         ],
//         onChanged: (itemId) {
//           if (itemId == 'logout') FirebaseAuth.instance.signOut();
//         },
//       ),
//     ),
//   ],
// ),
/*
StreamBuilder(
        stream: messages,
        builder: (ctx,AsyncSnapshot<QuerySnapshot> snapshot) {  // snapshot without null mark to get access to docs property
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            final   documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text(documents[index]['text']),
              ),
            );
          }
        },
      ),
            // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       FirebaseFirestore.instance
      //           .collection(ChatScreen.collectionPath)
      //           .add({'text': 'message added by button'});
      //     }),
 */
