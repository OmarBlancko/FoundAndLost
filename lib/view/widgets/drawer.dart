
import 'package:flutter/material.dart';
import 'package:found_and_lost/Controller/authController.dart';
import 'package:found_and_lost/view/screens/answers_screen.dart';
import 'package:found_and_lost/view/screens/chat_screen.dart';
import 'package:found_and_lost/view/screens/chats_headers_screen.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../helper/sizeHelper.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<NewUser>(context).signedUser;
    final size = SizeHelper(context);
    final iconSize = size.setWidth(26);
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.setHeight(40),
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesomeIcons.user,size: iconSize,),
            title: Text('Update Profile'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesomeIcons.reply,size: iconSize,),
            title: Text('Answers'),
            onTap: () {
              Navigator.of(context).pushNamed(AnswersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesomeIcons.comment,size: iconSize,),
            title: Text('Chats'),
            onTap: () {
              Navigator.of(context).pushNamed(ChatsHeadersScreen.routeName);

            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app,size: iconSize,),
            title: Text('Logout'),
            onTap: () {
              Provider.of<AuthenticationController>(context, listen: false).logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
