import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_and_lost/Controller/authController.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/helper/curve_painter.dart';
import 'package:found_and_lost/main.dart';
import 'package:found_and_lost/view/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../../helper/sizeHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../model/user.dart';
import '../widgets/user_image_picker.dart';

enum AuthMode { signUp, login }

AuthMode authMode = AuthMode.login;

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthenticationController authController = AuthenticationController();
  final userNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final _confirmPasswordController = TextEditingController();

  var _isLoading = false;
  bool _isObsecure = true;

  Map<String, String> userData = {
    'userId': '',
    'userName': '',
    'password': '',
    'confirmPassword': '',
    'email': '',
    'imageUrl':'',
  };
  File? _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);

    void _submit() async {
      FocusScope.of(context).unfocus();
      UserCredential userCredential;
      if ((userData['userName'] == '' ||
          userData['password'] == '' ||
          userData['confirmPassword'] == '' ||
          userData['email'] == '') &&
          authMode == AuthMode.signUp) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar('Please fill your data'));
        return;
      }
      if (_userImageFile == null && authMode == AuthMode.signUp) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar('Please select image'));
        return;
      }
      if (!userData['email']!.contains('@') &&
          !userData['email']!.contains('.com')) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar('Enter valid email'));
        return;
      }
      if (userData['password'] != _confirmPasswordController.text &&
          authMode == AuthMode.signUp) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar('Password doesn\'t match'));
        return;
      }
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final AuthenticatedUser newUser;
      try {
        // sign up case
        if (authMode == AuthMode.signUp) {
          final storage = FirebaseStorage.instance;

          await Provider.of<AuthenticationController>(context, listen: false).signUp(userData['email']!, userData['password']!);

          final ref = await storage.ref().child('user_images').child('$globalUserIdentification.jpg');

          await ref.putFile(_userImageFile!);
          final imageUrl = await ref.getDownloadURL();
          userData['imageUrl'] = imageUrl;
          if (kDebugMode) {
            print(imageUrl);
          }
          await Provider.of<UserDataController>(context, listen: false)
              .registerUser(userData)
              .then((value) => Navigator.of(context)
              .pushReplacementNamed(HomeScreen.routName));

          // await Provider.of<AuthenticationController>(context, listen: false)
          //     .registerUser(_guestData);
        }
        // login case
        else {
          await Provider.of<AuthenticationController>(context, listen: false)
              .login(userData['email']!, userData['password']!)
              .whenComplete(() async {
            await Provider.of<UserDataController>(context, listen: false)
                .getUserDataById(globalUserIdentification).whenComplete(() {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);

            });

          });
        }
      } on HttpException catch (error) {
        print(error.toString());
        var errorMessage = 'Authentication failed!';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage =
          'The email address is already in use by another account';
        } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          errorMessage = 'Too many attempts now, Please try again later ';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This email is invalid, Please try with valid email';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is weak, please use strong password';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password please enter correct password';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage =
          'This E-mail is not registered, please signup and try again!';
        }
        else if (error.toString().contains('wrong-password')) {
          errorMessage =
          'Wrong password!';
        }
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar("Invalid username or password "));
        return;

      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar("Invalid username or password " ));
        return;

      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            Container(
                height: size.setWidth(120),
                child: CustomPaint(
                  size: Size(size.getWidth(), size.getHeight()),
                  painter: CurvePainter(),
                  child: Center(
                    child: Text(
                      authMode == AuthMode.login ? 'Login' : 'SignUp',
                      style: TextStyle(
                          fontSize: size.setWidth(28),
                          color: Colors.white,
                          fontFamily: 'Nexa',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )),
            SizedBox(
              height: size.setHeight(100),
            ),
            Container(
              height: authMode == AuthMode.signUp
                  ? size.setHeight(560)
                  : size.setHeight(300),
              width: size.setWidth(340),
              child: Card(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      if (authMode == AuthMode.signUp)
                        UserImagePicker(_pickedImage),
                      if (authMode == AuthMode.signUp)
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: size.setWidth(7)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            width: size.setWidth(310),
                            child: TextFormField(
                              maxLines: 1,
                              decoration: InputDecoration(
                                  icon: FieldIcon(FontAwesomeIcons.user),
                                  hintText: 'Username'),
                              onChanged: (val) {
                                userData['userName'] = val;
                              },
                              onFieldSubmitted: (userName) {
                                FocusScope.of(context)
                                    .requestFocus(emailFocusNode);
                              },
                            ),
                          ),
                        ),
                      SizedBox(
                        height: size.setHeight(20),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: size.setWidth(7)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          width: size.setWidth(310),
                          child: TextFormField(
                              focusNode: emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  icon: FieldIcon(FontAwesomeIcons.at),
                                  hintText: 'Email'),
                              onChanged: (val) {
                                userData['email'] = val;
                              },
                              onFieldSubmitted: (email) {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocusNode);
                              }),
                        ),
                      ),
                      SizedBox(
                        height: size.setHeight(20),
                      ),
                      Flexible(
                        child: Container(
                          width: size.setWidth(310),
                          padding: EdgeInsets.only(left: size.setWidth(7)),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(size.setWidth(8))),
                          child: TextFormField(
                            focusNode: passwordFocusNode,
                            obscureText: _isObsecure,
                            maxLines: 1,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: Icon(_isObsecure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObsecure = !_isObsecure;
                                      });
                                    }),
                                icon: FieldIcon(FontAwesomeIcons.lock),
                                hintText: 'password'),
                            onChanged: (val) {
                              userData['password'] = val;
                            },
                            onFieldSubmitted: (password) {
                              if (authMode == AuthMode.signUp) {
                                FocusScope.of(context)
                                    .requestFocus(confirmPasswordFocusNode);
                              } else {
                                emailFocusNode.removeListener(() {});
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.setHeight(20),
                      ),
                      if (authMode == AuthMode.signUp)
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: size.setWidth(7)),
                            width: size.setWidth(310),
                            child: TextFormField(
                              obscureText: _isObsecure,
                              controller: _confirmPasswordController,
                              focusNode: confirmPasswordFocusNode,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  icon: FieldIcon(FontAwesomeIcons.lock),
                                  suffixIcon: IconButton(
                                      icon: Icon(_isObsecure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObsecure = !_isObsecure;
                                        });
                                      }),
                                  hintText: 'Confirm password'),
                              onFieldSubmitted: (_) {
                                emailFocusNode.removeListener(() {});
                              },
                              onChanged: (val) {
                                userData['confirmPassword'] = val;
                              },
                            ),
                          ),
                        ),
                      SizedBox(height: size.setHeight(40)),
                      if (_isLoading)
                        SpinKitPianoWave(
                          color: Theme.of(context).colorScheme.primary,
                        )
                      else
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black54),
                          ),
                          onPressed: _submit,
                          child: Text(
                            authMode == AuthMode.login ? 'Login' : 'Sign Up',
                            style: TextStyle(
                                fontSize: size.setWidth(20),
                                fontFamily: 'Nexa'),
                          ),
                        ),
                      SizedBox(
                        height: size.setHeight(20),
                      ),
                      if (_isLoading)
                        SpinKitPianoWave(
                          color: Theme.of(context).colorScheme.primary,
                        )
                      else
                        TextButton(
                          onPressed: () {
                            setState(() {
                              authController.SwitchAuthMode();
                            });
                            ;
                          },
                          child: Text(
                            authMode == AuthMode.login
                                ? 'Don\'t have account ? \n      Sign up now'
                                : 'Already have account ? \n   Press and login now',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FieldIcon extends StatelessWidget {
  late final IconData icon;
  FieldIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Icon(
      icon,
      color: Colors.grey,
      size: size.setWidth(22),
    );
  }
}

SnackBar getSnackBar(String msg) {
  return SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 2),
  );
}
