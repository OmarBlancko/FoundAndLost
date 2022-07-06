
import 'package:flutter/material.dart';
import 'package:found_and_lost/Controller/authController.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../helper/sizeHelper.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<NewUser>(context).signedUser;
    final size = SizeHelper(context);
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.setHeight(40),
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesomeIcons.user),
            title: Text('Update Profile'),
            onTap: () {},
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
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
