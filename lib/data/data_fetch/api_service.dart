import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/chat_room.dart';
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
    final data = await firestore
        .collection('chats')
        .where('users.$user1', isEqualTo: true)
        .where('users.$user2', isEqualTo: true)
        .get();
    if (data.docs.isEmpty) {
      //Create a new Chatroom
      final user_name = await FirebaseFirestore.instance
          .collection('users')
          .doc(user2)
          .get()
          .then((value) => value.data()!['name']);
      final imgURL = await FirebaseFirestore.instance
          .collection('users')
          .doc(user2)
          .get()
          .then((value) => value.data()!['avatarUrl']);
      final newId = await CreateNewChatroomID(user1, user2, user_name, imgURL);
      return newId;
    } else {
      final chatRoomId = data.docs[0].id;
      return chatRoomId;
    }
  }

  CreateNewChatroomID(
      String user1, String user2, String name, String imgURL) async {
    //pass in the name and the avatar url
    final uuid = Uuid();
    final newId = uuid.v4();
    final newChatRoom = ChatRoom(
        name: name,
        users: {
          user1: true,
          user2: true,
        },
        avatarUrl: imgURL);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('chats').doc(newId).set(newChatRoom.toJson());
    return newId;
  }

  Stream getChatRoomMessages(String chatRoomId) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final messages = firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
    messages.listen((event) {
      event.docChanges.forEach((element) {
        if (element.type == DocumentChangeType.added) {
          print("added new message : ${element.doc.data()!['message']}");
          print("Sender : ${element.doc.data()!['sender']}");
        }
      });
    });
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

  Stream getUserModel(String userID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final data = firestore.collection('users').doc(userID).snapshots();
    yield data;
  }

  void deleteChats(String chatRoomId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('chats').doc(chatRoomId).delete();
  }

  const ApiService();
}
