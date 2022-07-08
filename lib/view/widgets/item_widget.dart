import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/view/screens/question_screen.dart';
import 'package:provider/provider.dart';

import '../../model/post.dart';

class ItemWidget extends StatelessWidget {
  late final Post post;
  ItemWidget(this.post);

  var dummyProfilePic =
      'https://firebasestorage.googleapis.com/v0/b/foundandlost-654ba.appspot.com/o/user_images%2Fdummy-profile-pic.png?alt=media&token=1c7fb0cc-b652-451a-9995-095d59316827';

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Container(
        margin: EdgeInsets.symmetric(vertical: size.setHeight(5)),
        width: size.setWidth(350),
        height: size.setHeight(180),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(size.setWidth(8))),
            border: Border.all(color: Colors.blueGrey, width: 2)),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: size.setWidth(8), top: size.setHeight(8)),
                  child: CircleAvatar(
                    radius: size.setWidth(16),
                    backgroundImage: NetworkImage(post.userImageUrl),
                  ),
                ),
                Container(
                  width: size.setWidth(60),
                  padding: EdgeInsets.only(left: size.setWidth(5)),
                  child: Text(
                    post.userName,
                    style: TextStyle(
                        fontSize: size.setWidth(15),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans'),
                  ),
                ),
                SizedBox(width: size.setWidth(40)),
                Container(
                  margin: EdgeInsets.only(top: size.setHeight(8)),
                  width: size.setWidth(150),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: Text(
                          'Recently found',
                          style: TextStyle(
                            fontSize: size.setWidth(15),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.setWidth(100),
                        child: Text(
                          '${post.itemName}',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: size.setWidth(17),
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.setHeight(10),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: size.setWidth(8)),
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: size.setWidth(14),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
             Container(
              padding: EdgeInsets.all(size.setHeight(8)),
              width: size.setWidth(350),
              height: size.setHeight(50),
              child: Text(
                '${post.postText}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: size.setWidth(14),
                ),

              ),
            ),
                 Container(
              padding: EdgeInsets.all(size.setHeight(8)),
              width: size.setWidth(350),
              height: size.setHeight(40),
              child: Row(
                children: <Widget>[
                  Text(
                    'Do you think it yours ?',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: size.setWidth(14),
                    ),
                  ),
                  SizedBox(
                    width: size.setWidth(30),
                  ),
                       Container(
                        height: size.setHeight(70),
                    child: ElevatedButton(
                      child: Text('Answer now',style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: size.setWidth(14),
                      ),),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionScreen(post.questionId)));                      },

                  )),
                ],
              ),
            ),
          ],
        ));
  }
}
// Container(
//   margin: EdgeInsets.only(
//       left: size.setWidth(8), top: size.setHeight(8)),
//   child: FutureBuilder(
//     future:
//         Provider.of<UserDataController>(context,listen: false)
//             .getUserDataById(widget.post.userId),
//     builder: (_, snapshot) {
//       print('from widget view : ${widget.post.userName}');
//       if (snapshot.connectionState == ConnectionState.done) {
//         return Consumer<UserDataController>(
//             builder: (_, userData, child) {
//           return CircleAvatar(
//             radius: size.setWidth(16),
//             backgroundImage:
//                 NetworkImage(userData.user!.imageUrl),
//           );
//         });
//       } else {
//         return CircleAvatar(
//           backgroundImage: NetworkImage(dummyProfilePic),radius: size.setWidth(16),);
//       }
//     },
//   ),
// ),
