// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_and_lost/view/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AuthenticationController with ChangeNotifier {
  String? _token;
  String? _userId;
  AuthenticationController();

  late User user;
  UserCredential? userCredential;

  final authFirebaseInstance = FirebaseAuth.instance;


  String? get token {
    if ( _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String? get userId {
    if (_userId != null) {
      return _userId;
    } else {
      return null;
    }
  }

  bool get isAuth {
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> authUser(String email, String password, AuthMode auth) async {
      if (auth == AuthMode.login) {
        userCredential = await authFirebaseInstance.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await authFirebaseInstance.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      _userId = userCredential!.user!.uid;
      _token = await userCredential!.user!.getIdToken();
      globalUserIdentification = userCredential!.user!.uid;
      print(_token);
      print(globalUserIdentification);
      isAuth;
      notifyListeners();

      /// to store user data on device
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'email': email,
        'password': password,
      });
      // print(userData);
      prefs.setString('userData', userData);

  }



  Future<void> signUp(String email, String password) async {
    return authUser(email, password, AuthMode.signUp);
  }

  Future<void> login(String email, String password) async {
    return authUser(email, password, AuthMode.login);
  }

  Future<bool> tryAutoLogin() async {

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
    json.decode(prefs.getString('userData') ?? '') as Map<String, dynamic>;

    final email = extractedData['email'];
    final password = extractedData['password'];

    if (email == null && password == null) {
      return false;
    }
    final UserCredential? loginResponse = await authFirebaseInstance.signInWithEmailAndPassword(email: email, password: password);
    if (loginResponse!.user?.uid == null) {
      return false;
    } else
      globalUserIdentification = loginResponse.user!.uid;
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.remove('guestInfo');
    prefs.clear();
  }
  void SwitchAuthMode() {
    if (authMode == AuthMode.signUp) {
      authMode = AuthMode.login;
    } else {
      authMode = AuthMode.signUp;
    }
  }
}
