import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:found_and_lost/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class UserDataController with ChangeNotifier {
  AuthenticatedUser? user;
  Future<AuthenticatedUser?> get currentUserInfo async {
    if (user == null) {
      await getUserData();
      return user;
    } else {
      await getUserData();

      return user;
    }
  }

  Future<void> registerUser(Map<String, String> guestData) async {
    final user = <String, dynamic>{
      'userID': globalUserIdentification,
      'email': guestData['email'],
      'userName': guestData['userName'],
      'password': guestData['password'],
      'imageUrl': guestData['imageUrl']
    };
    try {
      final db = FirebaseFirestore.instance;
      await db.collection('users').doc(globalUserIdentification).set(user);
      currentUserImageUrl = guestData['imageUrl'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final guestInfo = json.encode({
        'email': guestData['email'],
        'userName': guestData['userName'],
        'password': guestData['password'],
        'imageUrl': guestData['imageUrl']
      });
      await prefs.setString('guestInfo', guestInfo);
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchUserData() async {
    AuthenticatedUser temp;
    try {
      final db = FirebaseFirestore.instance;

      final docRef = await db.collection('users').doc(globalUserIdentification);
      final ref = docRef.get();
      await docRef.get().then(
        (DocumentSnapshot doc) async {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          AuthenticatedUser snapShotData = AuthenticatedUser(
              id: data['userID'],
              name: data['userName'],
              password: data['password'],
              email: data['email'],
              imageUrl: data['imageUrl']);
          currentUserImageUrl = data['imageUrl'];
          if (snapShotData.id == FirebaseAuth.instance.currentUser!.uid) {
            final prefs = await SharedPreferences.getInstance();
            final guestInfo = json.encode({
              'userName': snapShotData.name,
              'password': snapShotData.password,
              'email': snapShotData.email,
              'imageUrl': snapShotData.imageUrl
            });
            await prefs.setString('guestInfo', guestInfo);
          }
          user = snapShotData;
          print(snapShotData.name);
        },
        onError: (e) => print(e),
      );
    } catch (error) {
      print(error);
    }
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('guestInfo') || prefs.get('guestInfo') == null) {
      if (kDebugMode) {
        print('not exist');
      }
      fetchUserData();
      return;
    } else {
      if (kDebugMode) {
        print('exist');
      }
      final _extractedData = json.decode(prefs.getString('guestInfo') ?? '')
          as Map<String, dynamic>;
      final AuthenticatedUser temp = AuthenticatedUser(
        id: globalUserIdentification,
        name: _extractedData['userName'],
        password: _extractedData['password'],
        email: _extractedData['email'],
        imageUrl: _extractedData['imageUrl'],
      );
      user = temp;
    }
  }

  Future<AuthenticatedUser?> getUserDataById(String userId) async {
    late final AuthenticatedUser u;
    try {
      final db = FirebaseFirestore.instance;

      final docRef = await db.collection('users').doc(userId);
      final ref = docRef.get();
      await docRef.get().then(
            (DocumentSnapshot doc) async {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          AuthenticatedUser snapShotData = AuthenticatedUser(
              id: data['userID'],
              name: data['userName'],
              password: data['password'],
              email: data['email'],
              imageUrl: data['imageUrl']);

          user = snapShotData;
          // print('from single retrive data   ${user!.imageUrl}');
        },
        onError: (e) => print(e),
      );
      return user;

    } catch (error) {
      print('error in get user data by id : $error');
    }
  }
}
