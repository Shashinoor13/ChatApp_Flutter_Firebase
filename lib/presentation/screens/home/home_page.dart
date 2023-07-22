import 'package:chats/data/data_fetch/api_service.dart';
import 'package:chats/presentation/screens/chat/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/model/user.dart' as local;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // String currentUserId = "T8tAu1BCUcdRIH83Od1zQdwSisX2";
    return Scaffold(
        body: Center(
            child: StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator.partiallyRevealed();
        }
        if (snapshot.hasData) {
          print(snapshot.data!.docs.length);
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return ListTile(
                onTap: () async {
                  local.User user =
                      await const ApiService().getUserModel(currentUserId);
                  ds["users"].remove(currentUserId);
                  local.User otherUser = await const ApiService()
                      .getUserModel(ds["users"].keys.last);
                  String chatRoomId = await const ApiService()
                      .getChatRoomID(currentUserId, ds["users"].keys.last);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatPage(
                            chatRoomID: chatRoomId,
                            currentUserModel: user,
                            messageUserModel: otherUser,
                          );
                        },
                      ),
                    );
                  }
                },
                title: Text(ds["name"]),
              );
            },
          );
        }
        return const CircularProgressIndicator();
      },
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where("users.$currentUserId", isEqualTo: true)
          .snapshots(),
    )));
  }
}
