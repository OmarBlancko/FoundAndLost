import 'package:flutter/material.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';

class UserNameAndAvatar extends StatelessWidget {
  late final String urlImageUrl;
  late final String userName;
  UserNameAndAvatar(this.userName,this.urlImageUrl);

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(urlImageUrl),
          radius: size.setWidth(18),
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
                fontWeight: FontWeight.w500,
                fontSize: size.setWidth(14)),
          ),
        ),
      ],
    );
  }
}
