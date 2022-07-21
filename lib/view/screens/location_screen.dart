import 'package:flutter/material.dart';
import 'package:found_and_lost/helper/location_helper.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';

class LocationScreen extends StatefulWidget {
static const routeName='LocationScreen';
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    final imagePreivew = LocationHelper.generateLocationPreviewImage(latitude: 	30.013056, longitude: 31.208853); // static coordinations
    return Scaffold(
      body:Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: size.setHeight(60),
            color: Colors.teal,
            padding: EdgeInsets.only(left: size.setWidth(10)),
            child: Row(
              children: <Widget>[
                BackButton(),
                SizedBox(width: size.setWidth(90),),
                Container(
                  width: size.setWidth(100),
                  child: Text('Safe point',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: size.setWidth(14),color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.setHeight(20),),
          SizedBox(
            height: size.setHeight(300),
            width: size.setWidth(350),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(imagePreivew),
            ),
          ),
        ],
      )

    );
  }
}
