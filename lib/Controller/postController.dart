import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:found_and_lost/Controller/questionController.dart';
import 'package:found_and_lost/main.dart';
import '../model/post.dart';

class PostController with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts {
    return [..._posts];
  }

  final db = FirebaseFirestore.instance;

  Future<void> fetchAndSetPosts() async {
    try {
      List<Post> loadedPosts = [];
      late List<dynamic> temp;
      await db.collection('posts').get().then((value) {
        temp = value.docs.toList();
      });
      for (var post in temp) {
        loadedPosts.add(Post(
            postId: post['postId'],
            postingDate: post['postingDate'].toString(),
            postText: post['postText'],
            itemName: post['itemName'],
            userName: post['userName'],
            userId: post['userId']));
      }
      _posts = loadedPosts;
      // print(_posts.length);

      // for (var element in _posts) {
      //   if (kDebugMode) {
      //     print(element.postText);
      //   }
      // }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error in fetching posts : $e');
      }
    }
  }
  Future<void> getUserPostsByID(String id) async {
    try {
      List<Post> loadedPosts = [];
      late List<dynamic> temp;
      // final FirebaseAuth _auth =FirebaseAuth.instance;
      // final userId = _auth.currentUser!.uid;
      await db.collection('posts').where('userId',isEqualTo: id).get().then((value) {
        temp = value.docs.toList();
      });
      for (var post in temp) {
        loadedPosts.add(Post(
            postId: post['postId'],
            postingDate: post['postingDate'],
            postText: post['postText'],
            itemName: post['itemName'],
            userName: post['userName'],
            userId: post['userId']));
      if (kDebugMode) {
        print(post['userName']);
      }
      }
      _posts = loadedPosts;
      if (kDebugMode) {
        print(_posts[0].userId);
      }
      loadedPosts.clear();
      temp.clear();

      notifyListeners();
    }
    catch (error)
    {
      if(kDebugMode)
        {
          print('error in fetching user posts $error');
        }
    }
  }
  Future<void> createPost(Post post) async {
    final postTemp = <String, dynamic>{
      'postId': post.postId,
      'postingDate': DateTime.now(),
      'postText': post.postText,
      'itemName': post.itemName,
      'userName': post.userName,
      'questionId': questionIdentification,
      'userId': post.userId
    };
    //  final Question q = Question('1', 'First Question ?');
    //  final  qController = QuestionController();
    //  await qController.addQuestion(q);
    // final postTemp = <String,dynamic> {
    //   'postId':'1',
    //   'postingDate':DateTime.now().toString(),
    //   'postText':'new post',
    //   'itemName':'watch ',
    //   'userName':'omar',
    //   'questionId':questionIdentification,
    //   'userId':'3'
    // };
    try {
      await db.collection('posts').add(postTemp).then((documentSnapshot) async {
        await db
            .collection('posts')
            .doc(documentSnapshot.id)
            .update({'postId': documentSnapshot.id}).then((value) {
          if (kDebugMode) {
            print('post added successfully with id');
          }
        });
      }, onError: (e) {
        if (kDebugMode) {
          print('error updating post : $e');
        }
      });
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error in adding lost item : $error');
      }
    }
  }

  Future<void> editPost(Post post) async {
    try {
      await db
          .collection('posts')
          .doc(post.postId)
          .update({'postText': post.postText}).then((value) {
        print('post updated successfully');
      });
    } catch (e) {
      if (kDebugMode) {
        print('error in editing post : $e');
      }
    }
  }

  Future<void> deletePost(Post post) async {
    try {
      await db.collection('posts').doc(post.postId).delete().then((value) {
        if (kDebugMode) {
          print('post deleted successfully');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('error in deleting post : $e');
      }
    }
  }
}
// late final String postId;
// late final DateTime postingDate;
// late final String postText;
// late final Item item;
// late final String userName;
// late final String questionId;
// late final String userId;
