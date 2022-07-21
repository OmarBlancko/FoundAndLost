// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_and_lost/Controller/answerController.dart';
import 'package:found_and_lost/Controller/postController.dart';
import 'package:found_and_lost/view/widgets/answer_widget.dart';
import 'package:found_and_lost/view/widgets/drawer.dart';
import 'package:found_and_lost/view/widgets/post_widget.dart';
import 'package:provider/provider.dart';

import '../../helper/sizeHelper.dart';
import '../../model/answer.dart';
import '../../model/post.dart';

class AnswersScreen extends StatefulWidget {
  static const routeName = 'AnswersScreen';
  @override
  State<AnswersScreen> createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  var isLoading = false;
  var checkText;
  List<Post?> myPosts = [];
  Map<String, List<Answer>> postsAnswers =
      {}; // store every question id with all of its answers
  List<Answer?> answers = [];

  _loadMyPosts() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 0)).then((value) async {
      await Provider.of<PostController>(context, listen: false)
          .getUserPostsByID(FirebaseAuth.instance.currentUser!.uid)
          .then((value) async {
        setState(() {
          myPosts = Provider.of<PostController>(context, listen: false).posts;
        });
        await _loadQuestionAnswers();
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  _loadQuestionAnswers() async {
    setState(() {
      isLoading = true;
    });
    for (var post in myPosts) {
      await Provider.of<AnswerController>(context, listen: false)
          .getQuestionAnswers(post!.questionId);
      Map<String, List<Answer>> temp = {};
      postsAnswers.addAll({
        post.questionId:
            Provider.of<AnswerController>(context, listen: false).answers
      });
      // print(postsAnswers);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _loadMyPosts();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnswersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadMyPosts();
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);

    return Scaffold(
      body: Center(
          child: Container(
        height: size.setHeight(850),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackButton(),
            Container(
              height: size.setHeight(250),
              width: double.infinity,
              child: FittedBox(
                child: Image.asset('assets/images/FoundAndLost.jpg'),
              ),
            ),
            Container(
              height: size.setHeight(22),
              padding: EdgeInsets.only(left: size.setWidth(35)),
              child: Text(
                'Your posts and answers on them',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: size.setHeight(21),
                  fontFamily: 'Roboto'
                ),
              ),
            ),
            SizedBox(
              height: size.setHeight(20),
            ),
            isLoading == true
                ? const Center(
                    child: SpinKitThreeInOut(
                      color: Colors.blueGrey,
                    ),
                  )
                : Expanded(
                  child: Container(
                      height: size.setHeight(480),
                      child: ListView.builder(
                          itemCount: myPosts.length,
                          itemBuilder: (context, index) => Center(
                                  child: Column(
                                children: <Widget>[
                                  PostWidget(myPosts[index]),
                                  Container(
                                    child: Container(
                                      height: size.setHeight(200),
                                      child: postsAnswers[
                                                  myPosts[index]!.questionId]!
                                              .isEmpty
                                          ? const Center(
                                              child: Text(
                                                  'No answers submitted yet'),
                                            )
                                          : ListView.builder(
                                              itemCount: postsAnswers[
                                                      myPosts[index]!.questionId]!
                                                  .length,
                                              itemBuilder: (context, i) => AnswerWidget(
                                                  postsAnswers[myPosts[index]!.questionId]![i]),
                                            ),
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                ),
          ],
        ),
      )),
    );
  }
}
// Text(myPosts[index]!.itemName)
