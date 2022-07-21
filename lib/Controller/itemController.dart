import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/item.dart';

class ItemController with ChangeNotifier {
  ItemController();
  late final Item? item;

  final db = FirebaseFirestore.instance;

  Future<void> addItem(Item item) async {
    final tempItem = <String, String>{
      'itemId': DateTime.now().toString(),
      'name': item.name,
    };
    try {
      await db.collection('items').add(tempItem).then((documentSnapshot) async {
        await db
            .collection('items')
            .doc(documentSnapshot.id)
            .update({'itemId': documentSnapshot.id}).then((value) {
          print('added successfully with id');
        });
      }, onError: (e) {
        print('error updating : $e');
      });
      notifyListeners();
    } catch (e) {
      print('error in adding item : $e');
    }
  }

  Future<Item?> getItemById(String id) async {
    try {
      final docRef = await db
          .collection('items')
          .doc(id)
          .get()
          .then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['itemId'] != null) {
          item!.itemId = data['itemId'];
          item!.name = data['name'];
        }
      });
      notifyListeners();
    } catch (e) {
      print('error in fetching item : $e');
    }
    return item;
  }
}
