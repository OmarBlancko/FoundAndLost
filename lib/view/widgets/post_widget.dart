import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';

import '../../model/post.dart';

class PostWidget extends StatelessWidget {
  // shown in posts and answers screen
  late final Post? post;
  PostWidget(this.post);
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Container(
      height: size.setHeight(80),
      width: size.setWidth(370),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.all(Radius.circular(size.setWidth(10))),
      ),
      padding: EdgeInsets.only(left: size.setWidth(14),bottom: size.setWidth(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(child: Container(
                  width: size.setWidth(130),
                  height: size.setHeight(50),
                  child: Text(post!.itemName,style: TextStyle(
                      fontSize: size.setWidth(18),
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),)),),
              SizedBox(
                width: size.setWidth(170),
              ),
            ],
          ),
          SizedBox(height: size.setHeight(5),),
          Container(
              padding: EdgeInsets.only(left: size.setWidth(5)),
              child: Text('Answers submitted',style: TextStyle(fontSize: size.setWidth(15)),)),
        ],
      ),
    );
  }
}
// IconButton(
//     onPressed: () {},
//     icon: Icon(
//       FontAwesomeIcons.pen,
//       color: Colors.teal,
//       size: size.setWidth(21),
//     )),
