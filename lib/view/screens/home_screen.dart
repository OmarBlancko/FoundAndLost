import 'package:flutter/material.dart';
import 'package:found_and_lost/Controller/postController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/main.dart';
import 'package:found_and_lost/view/screens/add_item_screen.dart';
import 'package:found_and_lost/view/screens/lost_items_screen.dart';
import 'package:found_and_lost/view/widgets/drawer.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatelessWidget {
static const routName = '/HomeScreen';
  @override
  final globalKey = GlobalKey<ScaffoldState>();

Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Scaffold(
      drawer: AppDrawer(),
      key: globalKey,
      body: SafeArea(child: Builder(
        builder: (context) =>SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.menu, size: size.setHeight(30)), onPressed: () async {
                    // await Provider.of<PostController>(context,listen: false).fetchAndSetPosts();
                    globalKey.currentState?.openDrawer();

                  }),
                ],
              ),
              Container(
                height: size.setHeight(350),
                width: double.infinity,
                child:             FittedBox(child: Image.asset('assets/images/FoundAndLost.jpg'),),
              ),          ElevatedButton(onPressed: () {
                Navigator.of(context).pushNamed(LostItemsScreen.routeName);
              }, child: Text(
                'Find lost item',style: TextStyle(fontSize: size.setHeight(22)),
              ),
              ),

              SizedBox(height: size.setHeight(50),),
              ElevatedButton(onPressed: () {
                Navigator.of(context).pushNamed(AddItemScreen.routeName);
              }, child: Text(
                'Post a lost item ',style: TextStyle(fontSize: size.setHeight(22)),
              ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
