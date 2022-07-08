import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_and_lost/Controller/postController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/view/widgets/item_widget.dart';
import 'package:provider/provider.dart';

class LostItemsScreen extends StatefulWidget {
  static const routeName = 'LostItemsScreen';

  @override
  State<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  @override


  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: size.setHeight(250),
              width: double.infinity,
              child: FittedBox(
                child: Image.asset('assets/images/FoundAndLost.jpg'),
              ),
            ),
            Flexible(
              child: Container(
                height: size.setHeight(600),
                child: FutureBuilder(
                  future: Provider.of<PostController>(context, listen: false)
                      .fetchAndSetPosts(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Consumer<PostController>(
                          builder: (_, postsData, child) {
                        // print(postsData.posts.length);
                        if (postsData.posts.length == 0) {
                          return const Center(child: Text('There\'s no lost items now :('),);
                        } else {
                          return ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: postsData.posts.length,
                            itemBuilder: (ctx, i) =>
                                ItemWidget(postsData.posts[i]),
                          );
                        }
                      });
                    } else {
                      return const SpinKitThreeInOut(
                        color:Colors.blueGrey,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
