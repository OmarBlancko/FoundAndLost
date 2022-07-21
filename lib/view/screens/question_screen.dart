import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_and_lost/Controller/answerController.dart';
import 'package:found_and_lost/Controller/postController.dart';
import 'package:found_and_lost/helper/sizeHelper.dart';
import 'package:found_and_lost/main.dart';
import 'package:provider/provider.dart';

import '../../Controller/questionController.dart';
import 'auth_screen.dart';

class QuestionScreen extends StatefulWidget {
  static const routeName = 'QuestionScreen';

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  dynamic questionText;
  dynamic itemName;
  dynamic postText;
  final answerController = TextEditingController();
  var _isLoading = false;

  _loadQuestion() async {
    // print('init Started');
    setState(() {});
    Future.delayed(const Duration(seconds: 0)).then((value) async {
      // fetching question of item
      final data = await Provider.of<QuestionController>(context, listen: false)
          .getQuestionById(globalQuestionIdentification);
      final post = Provider.of<PostController>(context, listen: false)
          .getPostById(globalPostIdentification);

      setState(() {
        itemName = post.itemName;
        postText = post.postText;
        questionText = data?.questionText;
      });
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadQuestion();
  }

  @override
  void didUpdateWidget(covariant QuestionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      questionText = null;
    });
    _loadQuestion();
  }



  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);

    _submitAnswer() async {
      FocusScope.of(context).unfocus();
      if(answerController.text == '' || answerController.text.isEmpty || answerController.text.length < 5) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackBar('Please enter your valid answer'));
        return;
      }
      setState(() {
        _isLoading = true;
      });
      Future.delayed(Duration(seconds: 0)).then((value) async{
        await Provider.of<AnswerController>(context,listen: false).addAnswer(answerController.text);
      }).then((value) {

        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Center(
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: size.setWidth(20)),
                  )),
              content: Container(
                height: size.setHeight(140),
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
                      'Your answer has been submited \n we will notify you soon',
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
      setState(() {
        _isLoading = false;
      });
    }
    final itemTextStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: size.setWidth(18),
        fontWeight: FontWeight.bold);
    final screenMargin = EdgeInsets.only(left: size.setWidth(14));
    return Scaffold(
      body: questionText == null
          ? const Center(
              child: SpinKitThreeInOut(
                color: Colors.blueGrey,
              ),
            )
          : SafeArea(
              child: Builder(
              builder: (context) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // app logo
                    SizedBox(
                      height: size.setHeight(250),
                      width: double.infinity,
                      child: FittedBox(
                        child: Image.asset('assets/images/FoundAndLost.jpg'),
                      ),
                    ),
                    Container(
                      height: size.setHeight(20),
                      margin: screenMargin,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Item founded  ',
                            style: itemTextStyle,
                          ),
                          SizedBox(
                            width: size.setWidth(50),
                          ),
                          Text(
                            '${itemName}',
                            style: itemTextStyle.copyWith(color: Colors.green),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.setHeight(20),
                    ),
                    Container(
                      height: size.setHeight(20),
                      margin: screenMargin,
                      child: Text(
                        'Description ',
                        style: itemTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: size.setHeight(20),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: size.setWidth(14)),
                      height: size.setHeight(100),
                      child: Text(
                        '${postText}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: size.setWidth(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.setHeight(20),
                    ),
                    const Divider(),
                    Container(
                      margin: screenMargin,
                      height: size.setHeight(45),
                      child: Text(
                        'If you think it\'s your lost item ! answer the following quesiton',
                        style:
                            itemTextStyle.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: size.setHeight(10),
                    ),
                    Container(
                      margin: screenMargin,
                      height: size.setHeight(50),
                      child: Text(
                        'Question : $questionText',
                        style: itemTextStyle.copyWith(color: Colors.red),
                      ),
                    ),
                    // text field for answer text
                    Container(
                      height: size.setHeight(80),
                      margin: EdgeInsets.symmetric(
                          vertical: size.setHeight(8),
                          horizontal: size.setWidth(14)),
                      child:  TextField(
                        controller: answerController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.setHeight(10),
                    ),
                    if(_isLoading)
                    CircularProgressIndicator()
                      else
                    Container(
                      margin: EdgeInsets.only(left: size.setWidth(115)),
                      child: ElevatedButton(
                          onPressed: _submitAnswer, child: Text('Submit answer now')),
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}
