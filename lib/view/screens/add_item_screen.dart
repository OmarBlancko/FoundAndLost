
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_and_lost/Controller/postController.dart';
import 'package:found_and_lost/Controller/questionController.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/main.dart';
import 'package:found_and_lost/model/post.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/AddItemScreen';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final postTextFocusNode = FocusNode();

  final questionTextFocusNode = FocusNode();

  var _isLoading = false;

  Map<String, dynamic> postData = {
    'itemName': '',
    'postText': '',
    'questionText': ''
  };

  var userName;
  @override
  void didChangeDependencies() async {
      final user =
          await Provider.of<UserDataController>(context).currentUserInfo;
      setState((){
        userName = user!.name;
      }) ;

    super.didChangeDependencies();
  }
@override
  void dispose() {
    userName ==null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);

    void _trySubmit() async {
      if (postData['itemName'] == '' ||
          postData['postText'] == '' ||
          postData['questionText'] == '') {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar('Please fill post data'));
        return;
      }
      if(postData['itemName'].length < 2 ||
          postData['postText'].length < 10||
          postData['questionText'].length < 10)
      {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar('Data is too short, enter full data please'));
        return;
      }
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<QuestionController>(context, listen: false)
            .createQuestion(postData['questionText'])
            .then((value) async {
          final tempPost = Post(
              postId: '',
              postingDate: DateTime.now().toString(),
              postText: postData['postText'],
              itemName: postData['itemName'],
              userName: userName,
              userId: globalUserIdentification,
            questionId: globalQuestionIdentification,
            userImageUrl: currentUserImageUrl,
          );
          await Provider.of<PostController>(context, listen: false)
              .createPost(tempPost)
              .then((value) {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Center(
                          child: Text(
                        'Done',
                        style: TextStyle(fontSize: size.setWidth(20)),
                      )),
                      content: Container(
                        height: size.setHeight(130),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.circleCheck,
                              color: Colors.greenAccent,
                              size: size.setWidth(44),
                            ),
                            SizedBox(
                              height: size.setHeight(15),
                            ),
                            Text(
                              'Thank you post uploading done',
                              style: TextStyle(
                                  fontSize: size.setWidth(22),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              'Back to home',
                              style: TextStyle(
                                fontSize: size.setWidth(18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )).then((value) {
              Navigator.pop(context);
            });
          });
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error in adding question : $e');
        }
      }
      setState(() {
        _isLoading = false;
      });
    }

    // final userInfo = Provider.of<UserDataController>(context).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 800,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.setHeight(40),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(size.setWidth(8))),
                      border: Border.all(color: Colors.black54, width: 3)),
                  width: size.setWidth(340),
                  height: size.setHeight(150),
                  margin: EdgeInsets.only(left: size.setWidth(25)),
                  padding: EdgeInsets.all(size.setWidth(10)),
                  child: Consumer<UserDataController>(
                    builder: (_, userDataSnapshot, child) => Text(
                      'Hello ${userDataSnapshot.user?.name ?? 'dear'}, \nThank you for being cooperative person',
                      style: TextStyle(
                          fontSize: size.setWidth(24),
                          fontFamily: 'Nexa',
                          fontWeight: FontWeight.bold),
                    ),

                  ),
                ),
              ),
              SizedBox(
                height: size.setHeight(20),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: size.setWidth(24)),
                  child: Text(
                    'You can share post with lost item now',
                    style: TextStyle(fontSize: size.setWidth(18)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.setWidth(10)),
                margin: EdgeInsets.all(size.setWidth(10)),
                height: size.setHeight(400),
                width: size.setWidth(380),
                child: Card(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LabelText('Item name'),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: size.setWidth(7)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            width: size.setWidth(310),
                            child: TextFormField(
                              maxLines: 1,
                              decoration:
                                  InputDecoration(hintText: 'Item name'),
                              onChanged: (itemName) {
                                postData['itemName'] = itemName;
                              },
                              onFieldSubmitted: (itemName) {
                                FocusScope.of(context)
                                    .requestFocus(postTextFocusNode);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.setHeight(10),
                        ),
                        LabelText('Description'),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: size.setWidth(7)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            width: size.setWidth(310),
                            child: TextFormField(
                              focusNode: postTextFocusNode,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                  hintText:
                                      'Add short description and the area you found it in'),
                              onChanged: (postText) {
                                postData['postText'] = postText;
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(questionTextFocusNode);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.setHeight(10),
                        ),
                        LabelText('Question'),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: size.setWidth(7)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            width: size.setWidth(310),
                            child: TextFormField(
                              focusNode: questionTextFocusNode,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                  hintText:
                                      'Add question related to item to identify the real owner '),
                              onChanged: (questionText) {
                                postData['questionText'] = questionText;
                              },
                              onFieldSubmitted: (value) {
                                questionTextFocusNode.removeListener(() {});
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.setHeight(15),
                        ),
                        if (_isLoading == false)
                          Row(
                            children: [
                              SizedBox(
                                width: size.setWidth(130),
                              ),
                              Flexible(
                                child: Container(
                                  child: ElevatedButton(
                                    child: Text('Add post'),
                                    onPressed: _trySubmit,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_isLoading == true)
                          Center(
                            child: SpinKitPianoWave(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  late final String text;
  LabelText(this.text);
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);

    return Container(
      padding: EdgeInsets.only(left: size.setWidth(8)),
      child: Text(
        '$text',
        style: TextStyle(
            fontSize: size.setWidth(17),
            fontFamily: 'Nexa',
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

SnackBar getSnackBar(String msg) {
  return SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 2),
  );
}
