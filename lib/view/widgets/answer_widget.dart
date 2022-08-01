import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_and_lost/Controller/answerController.dart';
import 'package:found_and_lost/Controller/userDataController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/main.dart';
import 'package:found_and_lost/model/user.dart';
import 'package:found_and_lost/view/screens/answers_screen.dart';
import 'package:found_and_lost/view/widgets/userName_and_avatar.dart';
import 'package:provider/provider.dart';
import '../../model/answer.dart';
import '../screens/chat_screen.dart';

class AnswerWidget extends StatefulWidget {
  late final Answer? answer;
  AnswerWidget(this.answer);
  @override
  State<AnswerWidget> createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  AuthenticatedUser? user;
  var _isLoading = false;
  _loadAnswererData() async {
    setState(() {
      _isLoading = true;
    });
    final AuthenticatedUser? temp =
        await Provider.of<UserDataController>(context, listen: false)
            .getUserDataById(widget.answer!.userId);
    user = temp;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAnswererData();
  }

  @override
  void didUpdateWidget(covariant AnswerWidget oldWidget) {
    if(user == null) {
      _loadAnswererData();
    }
    super.didUpdateWidget(oldWidget);
  }
  _rejectAnswer() async{
    setState(() {
      _isLoading= true;
    });
    await Provider.of<AnswerController>(context,listen: false).editAnswerStatus(widget.answer!.answerId, 'rejected');
    setState(() {
      _isLoading= false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  AnswersScreen()),
    );
  }
  _acceptAnswer() async{
    globalChatReceiverId=widget.answer!.userId;

    setState(() {
      _isLoading= true;
    });
    await Provider.of<AnswerController>(context,listen: false).editAnswerStatus(widget.answer!.answerId, 'accepted');
    setState(() {
      _isLoading= false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ChatScreen(widget.answer!.userId)),
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Container(
      height: size.setHeight(180),
      padding: EdgeInsets.only(left: size.setWidth(18)),
      child: _isLoading == true
          ? const Center(
              child: SpinKitPianoWave(
                color: Colors.blueGrey,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: size.setHeight(40),
                    child: Row(
                      children: <Widget>[
                        UserNameAndAvatar(user!.name, user!.imageUrl),
                        SizedBox(
                          width: size.setWidth(120),
                        ),
                        IconButton( // accept answer and open chat
                            onPressed: _acceptAnswer,
                            icon: Icon(
                              FontAwesomeIcons.circleCheck,
                              color: Colors.green,
                              size: size.setWidth(24),
                            )),
                        IconButton( // delete answer
                            onPressed:_rejectAnswer,
                            icon: Icon(FontAwesomeIcons.circleXmark,
                                color: Colors.red, size: size.setWidth(24))),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.setHeight(5),
                ),
                Container(
                  padding: EdgeInsets.only(left: size.setWidth(5)),
                  child: Text('Answer :',style: TextStyle(fontSize: size.setWidth(15)),),
                ),
                SizedBox(
                  height: size.setHeight(5),
                ),
                Container(
                  height: size.setHeight(95),
                  width: size.setWidth(350),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius:
                        BorderRadius.all(Radius.circular(size.setWidth(10))),
                  ),
                  padding: EdgeInsets.only(left: size.setWidth(5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.setWidth(5),
                                vertical: size.setHeight(4)),
                            child: Text(widget.answer!.answerText)),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 2),
              ],
            ),
    );
  }
}
