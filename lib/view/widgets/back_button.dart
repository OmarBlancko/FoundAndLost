import 'package:flutter/material.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Container(
      height: size.setHeight(50),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: size.setWidth(25),
            ),
          ),
        ],
      ),
    );
  }
}
