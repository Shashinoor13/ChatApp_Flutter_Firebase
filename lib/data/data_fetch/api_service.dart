import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chats.dart';
import '../model/user.dart';

class ApiService {
  getChatRooms(String userID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = firestore
        .collection("chats")
        .where("users.$userID", isEqualTo: true)
        .snapshots();
    //{users: {hello: true, shashi: true}}
    yield querySnapshot;
  }

  Future getChatRoomID(String user1, String user2) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print(user1);
    print(user2);
    final data = await firestore
        .collection('chats')
        .where('users.$user1', isEqualTo: true)
        .where('users.$user2', isEqualTo: true)
        .get();
    final chatRoomId = data.docs[0].id;
    return chatRoomId;
  }

  Stream getChatRoomMessages(String chatRoomId) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final messages = firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
    yield* messages;
  }

  deleteChatRoom() async {
    return true;
  }

  deleteChatRoomMessage(chatRoomId, id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(id)
        .delete();
  }

  createChatRoom() async {
    return true;
  }

  updateChatRoom() async {
    return true;
  }

  blockUser() async {}

  sendMessage(Chats message, String chatRoomId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toJson())
        .then((value) => print("message sent successfully $value"));
  }

  createUser(User newUser) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc(newUser.id).set(newUser.toJson());
  }

  getUserModel(String userID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final data = await firestore.collection('users').doc(userID).get();
    return User.fromJson(data.data()!);
  }

  const ApiService();
}
