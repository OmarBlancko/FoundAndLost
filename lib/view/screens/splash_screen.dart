// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_and_lost/view/screens/auth_screen.dart';
import 'package:found_and_lost/view/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../../Controller/authController.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    bool result = await Provider.of<AuthenticationController>(context,listen: false).tryAutoLogin();
    if(result == true) {
      print('auto login successfully');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  HomeScreen()));    }
    else {
      print('can\'t auto login');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  AuthScreen()));
    }

  }

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.setHeight(100),
          ),
          Text('Welcome to ',
              style: TextStyle(
                  fontSize: size.setWidth(32),
                  fontFamily: 'Aller',
                  fontWeight: FontWeight.bold),),
          Container(
            height: size.setHeight(400),
            width: double.infinity,
            child: FittedBox(
              child: Image.asset('assets/images/FoundAndLost.jpg'),
            ),
          ),
          SizedBox(
            height: size.setHeight(30),
          ),
          SpinKitWave(
            size: size.setWidth(70),
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
