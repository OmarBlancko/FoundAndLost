import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/view/screens/auth_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File? _pickedImage;
  void _pickImage() async {
    print('pressed');
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if(image?.path == null) {
      Scaffold.of(context).showSnackBar(getSnackBar('Please select image'));
    }
    setState(() {
    _pickedImage = File(image!.path);
    });
    widget.imagePickFn(_pickedImage!);
  }
@override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
          radius: 35,
        ),

        TextButton(
          onPressed: _pickImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.image,
                size: size.setWidth(25),
              ),
              Text(
                '  Add Image ',
                style: TextStyle(
                  fontSize: size.setWidth(16),
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
