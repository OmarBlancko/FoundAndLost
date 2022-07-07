import 'package:flutter/material.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';

import '../../model/post.dart';
class ItemWidget extends StatelessWidget {
  late final Post post;
  ItemWidget(this.post);
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Container(
      margin:EdgeInsets.symmetric(vertical: size.setHeight(5)) ,
      width: size.setWidth(350),
      height: size.setHeight(100),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(size.setWidth(8))),
          border: Border.all(color: Colors.blueGrey, width: 2)),
        child: Center(
        child: Text(post.itemName),
    ),
    );
  }
}
