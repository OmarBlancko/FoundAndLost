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
            postingDate: post['postingDate'].toString(), // need to modify
            postText: post['postText'],
            itemName: post['itemName'],
            userName: post['userName'],
            userId: post['userId'],
        userImageUrl: post['userImageUrl'],
        questionId: post['questionId']));
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
  Post getPostById(String postId) {
    // get post by  post id
    return _posts.firstWhere((element) => element.postId == postId);
  }
  Future<void> getUserPostsByID(String id) async {
    // get user's post by id
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
            postingDate: post['postingDate'].toString(),
            postText: post['postText'],
            itemName: post['itemName'],
            userName: post['userName'],
            userId: post['userId'],
            userImageUrl: post['userImageUrl'],
            questionId: post['questionId']));
      if (kDebugMode) {
        print(post['itemName']);
      }
      }
      _posts = loadedPosts;
      // if (kDebugMode) {
      //   print(_posts[0].userId);
      // }
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
      'postingDate': Timestamp.now(),
      'postText': post.postText,
      'itemName': post.itemName,
      'userName': post.userName,
      'questionId': globalQuestionIdentification,
      'userId': post.userId,
      'userImageUrl':globalCurrentUserImageUrl,
    };
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
