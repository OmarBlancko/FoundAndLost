import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';
import '../model/answer.dart';

class AnswerController with ChangeNotifier {
  List<Answer> _answers = [];
  List<Answer> get answers {
    return [..._answers];
  }
  Answer? answer;
  final db = FirebaseFirestore.instance;

  Future<void> addAnswer(String answerText) async {
    final tempQuestion = <String, String>{
      'answerId': DateTime.now().toString(),
      'answerText': answerText,
      'questionId': globalQuestionIdentification,
      'userId':FirebaseAuth.instance.currentUser!.uid,
      'answerStatus':'pending'
    };
    try {
      await db.collection('answers').add(tempQuestion).then(
          (documentSnapshot) async {
        globalAnswerIdentification = documentSnapshot.id;
        if (kDebugMode) {
          print(globalAnswerIdentification);
        }
        await db
            .collection('answers')
            .doc(documentSnapshot.id)
            .update({'answerId': documentSnapshot.id}).then((value) {
          if (kDebugMode) {
            print('answer added successfully with id');
          }
        });
      }, onError: (e) {
        if (kDebugMode) {
          print('error updating : $e');
        }
      });
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('error in adding answer : $e');
      }
    }
  }
  Future<void> getQuestionAnswers(String questionID) async {
    try{
      // fetch all  answers of question
      List<Answer> loadedAnswers = [];
      late List<dynamic> temp;
       // get only pending answers
      await db.collection('answers').where('questionId',isEqualTo: questionID).where('answerStatus',isEqualTo: 'pending').get().then((value) {
        temp = value.docs.toList();
      });

      for (var ans in temp) {
        loadedAnswers.add(Answer(answerId: ans['answerId'], answerText: ans['answerText'], questionId: ans['questionId'], userId: ans['userId']));
      }
      _answers =loadedAnswers;
      notifyListeners();

    }
    catch(e) {
      if(kDebugMode) {
        print('Error in get question answers');
      }
    }
  }
  Future<Answer?> getAnswerById(String id) async {
    try {
      final docRef = await db
          .collection('answers')
          .doc(id)
          .get()
          .then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // print(data);

        Answer ans = Answer(
            answerId: data['answerId'],
            answerText: data['answerText'],
            questionId: data['questionId'],
        userId: data['userId']);

        answer = ans;
      });
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('error in fetching answer : $e');
      }
    }
    return answer;
  }
  Future<void> editAnswerStatus(String ansId,String status) async {
    try {
      await db
          .collection('answers')
          .doc(ansId)
          .update({'answerStatus': status}).then((value) {
        if (kDebugMode) {
          print('answer updated successfully');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('error in editing answer status : $e');
      }
    }
  }

  Future<void> deleteAnswer(String id) async {
    try {
      await db.collection('answers').doc(id).delete().then((value) {
        if (kDebugMode) {
          print('answer deleted successfully');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('error in deleting answer : $e');
      }
    }
  }
}
