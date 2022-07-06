import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:found_and_lost/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class UserDataController with ChangeNotifier {
   AuthenticatedUser? user;
  Future<AuthenticatedUser?> get currentUserInfo async {
    if (user == null) {
      await getUserData();
      return user;
    }
    else {
      return user;
    }

  }
  Future<void> registerUser(Map<String, String> guestData) async {
    final user = <String, dynamic>{
      'userID': userIdentification,
      'email': guestData['email'],
      'userName': guestData['userName'],
      'password': guestData['password'],
    };
    try {
      final db = FirebaseFirestore.instance;
      await db.collection('users').doc(userIdentification).set(user);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final guestInfo = json.encode({
        'email': guestData['email'],
        'userName': guestData['userName'],
        'password': guestData['password'],
      });
      prefs.setString('guestInfo', guestInfo);
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchUserData() async {
    try {
      final db = FirebaseFirestore.instance;
      final docRef = db.collection('users').doc(userIdentification);
      await docRef.get().then(
            (DocumentSnapshot doc) async {
          final data = doc.data() as Map<String, dynamic>;

          AuthenticatedUser snapShotData = AuthenticatedUser(
              id: data['userID'],
              name: data['userName'],
              password: data['password'],
              email: data['email']);
          final prefs = await SharedPreferences.getInstance();
          final guestInfo = json.encode({
            'userName': snapShotData.name,
            'password': snapShotData.password,
            'email': snapShotData.email,
          });
          prefs.setString('guestInfo', guestInfo);
          user = snapShotData;
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
      print('not exist');
      fetchUserData();
      return;
    } else {
      print('exist');
      final _extractedData = json.decode(prefs.getString('guestInfo') ?? '')
      as Map<String, dynamic>;
      final AuthenticatedUser temp = AuthenticatedUser(
          id: userIdentification,
          name: _extractedData['userName'],
          password: _extractedData['password'],
          email: _extractedData['email']);
      user = temp;
    }
  }
}