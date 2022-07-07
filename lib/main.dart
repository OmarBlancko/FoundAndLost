// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:found_and_lost/Controller/authController.dart';
import 'package:found_and_lost/Controller/postController.dart';
import 'package:found_and_lost/Controller/questionController.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/model/question.dart';
import 'package:found_and_lost/view/screens/add_item_screen.dart';
import 'package:found_and_lost/view/screens/auth_screen.dart';
import 'package:found_and_lost/view/screens/home_screen.dart';
import 'package:found_and_lost/view/screens/lost_items_screen.dart';
import 'package:found_and_lost/view/screens/splash_screen.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import 'helper/custom_route.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MyApp());
}
// ignore: prefer_typing_uninitialized_variables
var userIdentification;
var questionIdentification;
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthenticationController()),
        ChangeNotifierProvider.value(value: UserDataController()),
        ChangeNotifierProvider.value(value: PostController()),
        ChangeNotifierProvider.value(value: QuestionController()),

      ],
      child: MaterialApp(
          title:  'Found And Lost',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme:ColorScheme.fromSwatch().copyWith(
              primary: Colors.teal,
              secondary: Colors.deepPurpleAccent,
            ),
            pageTransitionsTheme:PageTransitionsTheme(
                builders:{
                  TargetPlatform.android:CustomPageTransitionBuilder(),
                }
            ),
          ),
          routes: {
            '/':(ctx) => SplashScreen(),
            AuthScreen.routeName:(ctx) => AuthScreen(),
            HomeScreen.routName:(ctx) => HomeScreen(),
            AddItemScreen.routeName:(ctx) =>AddItemScreen(),
            LostItemsScreen.routeName:(ctx) =>LostItemsScreen(),
          },


      ),
    );

  }
}
