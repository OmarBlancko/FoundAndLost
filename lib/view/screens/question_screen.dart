import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Controller/questionController.dart';

class QuestionScreen extends StatefulWidget {
  static const routeName='QuestionScreen';
  late final String questionId;
  QuestionScreen(this.questionId);
  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var _isloading = false;
  var questionText;

  @override
   _loadQuestion () async{
  print('init Started');
  setState((){
    _isloading = true;
  });
  Future.delayed(const Duration(seconds: 0)).then((value) async {
    // fetching question of item
    final data = await Provider.of<QuestionController>(context,listen: false).getQuestionById(widget.questionId);

    setState((){
      questionText = data?.questionText;
    });
  });
  print(questionText);
  setState((){
    _isloading = false;
  });

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
    setState((){
      questionText = null;
    });
    _loadQuestion();
  }
  @override
  void dispose() {

  super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: questionText == null ? const Center(
          child: SpinKitThreeInOut(color: Colors.blueGrey,),
        ): Text('$questionText'),
      ),
    );
  }
}
