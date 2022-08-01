import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:found_and_lost/helper/sizeHelper.dart';

class MessageBubble extends StatelessWidget {
  late final String message;
  late final bool isMe;
  late final String username;
  late final String userImageUrl;
  final Key key;
  MessageBubble(this.message, this.isMe, this.username, this.userImageUrl,
      {required this.key});
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Row(
        // use row to get the width as i want not respect to list view
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Colors.black87,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.setWidth(12)),
                  topRight: Radius.circular(size.setWidth(12)),
                  bottomLeft: !isMe ? Radius.circular(size.setWidth(0)) : Radius.circular(size.setWidth(12)),
                  bottomRight: isMe ? Radius.circular(size.setWidth(0)) : Radius.circular(size.setWidth(12)),
                ),
              ),
              width: message.length.toDouble() + 150,
              padding: EdgeInsets.symmetric(vertical: size.setHeight(10), horizontal: size.setWidth(16)),
              margin: EdgeInsets.symmetric(
                vertical:size.setHeight(15),
                horizontal: size.setWidth(8),
              ),
              child: Stack(
                clipBehavior: Clip.none, // to allow overflow
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: size.setHeight(20),
                            width: size.setWidth(80),
                            child: Text(
                              username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isMe
                                      ? Colors.black
                                      : Colors
                                          .white), // Theme.of(context).accentTextTheme.title!.color
                            ),
                          ),
                           SizedBox(
                            height: size.setHeight(5),
                          ),
                          Text(
                            message,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color: isMe
                                  ? Colors.black
                                  : Colors
                                      .white, // Theme.of(context).accentTextTheme.title!.color
                            ),
                            textAlign: isMe ? TextAlign.end : TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: size.setWidth(5),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -20,
                    left: isMe ? null : 120,
                    right: isMe ? 120 : null,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userImageUrl),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
