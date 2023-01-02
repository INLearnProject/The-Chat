import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends ChangeNotifier {
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;

  static const String _discussionCollection = "discussions";
  static const String _discusssionChat = "chat";

  User? activeUser;

  Future<QuerySnapshot> getDiscussions() {
    return _cloudFirestore.collection("discussions").get();
  }

  Stream<QuerySnapshot> getChat(String discussionID) {
    return _cloudFirestore
        .collection(_discussionCollection)
        .doc(discussionID)
        .collection(_discusssionChat)
        .orderBy("date", descending: true)
        .snapshots();
  }

  sendNewDiscussion(String discussionName) {
    Map<String, dynamic> discussion = {
      "name": discussionName,
      "creatorID": activeUser!.uid
    };

    _cloudFirestore.collection(_discussionCollection).add(discussion);
    notifyListeners();
  }

  sendPostChat({required String postChat, required String discussionID}) {
    Map<String, dynamic> postData = {
      'sender': activeUser!.email,
      'content': postChat,
      'date': DateTime.now().toIso8601String()
    };

    _cloudFirestore
        .collection(_discussionCollection)
        .doc(discussionID)
        .collection(_discusssionChat)
        .add(postData)
        .catchError((error) {
      print(error);
    });
  }

  deleteDiscussion(String discussionID) {
    _cloudFirestore
        .collection(_discussionCollection)
        .doc(discussionID)
        .delete()
        .then((value) {
      return notifyListeners();
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> refreshDiscussions() async {
    notifyListeners();
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  Future<User?> checkIdentity({
    void Function()? onAuth,
    void Function()? onNoAuth,
  }) async {
    final User? user = _firebase.currentUser;
    if (user == null) {
      if (onNoAuth != null) {
        onNoAuth();
      }
    } else {
      if (onAuth != null) {
        onAuth();
      }
      activeUser = user;
    }
    print(activeUser);

    return activeUser;
  }

  void signOut() {
    _firebase.signOut();
  }
}
