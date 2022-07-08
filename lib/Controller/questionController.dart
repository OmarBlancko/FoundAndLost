import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:found_and_lost/main.dart';
import 'package:found_and_lost/model/question.dart';

class QuestionController with ChangeNotifier{
   Question? question;
  final db = FirebaseFirestore.instance;

  Future<void> createQuestion(String questionText) async {
    final tempQuestion = <String, String>{
      'questionId': DateTime.now().toString(),
      'questionText': questionText,
    };
    try {
      await db.collection('questions').add(tempQuestion).then((documentSnapshot) async {
        globalQuestionIdentification = documentSnapshot.id;
        print(globalQuestionIdentification);
        await db
            .collection('questions')
            .doc(documentSnapshot.id)
            .update({'questionId': documentSnapshot.id}).then((value) {
          print('question added successfully with id');
        });
      }, onError: (e) {
        print('error updating : $e');
      });
      notifyListeners();
    } catch (e) {
      print('error in adding item : $e');
    }
  }

  Future<Question?> getQuestionById(String id) async {
    try {

      late final Question q;
      final docRef = await db
          .collection('questions')
          .doc(id)
          .get()
          .then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // print(data);

          Question qs = Question(data['questionId'], data['questionText']);

        question = qs;

      });
      notifyListeners();
    } catch (e) {
      print('error in fetching question : $e');
    }
    return question;
  }
}