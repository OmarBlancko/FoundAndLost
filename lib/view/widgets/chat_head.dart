import 'package:flutter/material.dart';

import '../../helper/sizeHelper.dart';
import '../../main.dart';
import '../screens/chat_screen.dart';

class ChatHead extends StatelessWidget {
  late final String userId;
  late final String userName;
  late final String userImageUrl;
  ChatHead(
      {required this.userId,
      required this.userName,
      required this.userImageUrl});
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);

    return InkWell(
      onTap: () {
        globalChatReceiverId = userId;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(userId)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(size.setWidth(8))),
            border: Border.all(
              color: Colors.black12,
            )),
        height: size.setHeight(70),
        margin: EdgeInsets.symmetric(
            horizontal: size.setWidth(12), vertical: size.setHeight(4)),
        padding: EdgeInsets.symmetric(horizontal: size.setWidth(10)),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(userImageUrl),
              radius: size.setWidth(22),
            ),
            SizedBox(
              width: size.setWidth(10),
            ),
            Container(
              width: size.setWidth(100),
              child: Text(
                userName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: size.setWidth(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
