import 'package:chats/data/data_fetch/api_service.dart';
import 'package:chats/presentation/screens/chat/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // String currentUserId = "T8tAu1BCUcdRIH83Od1zQdwSisX2";
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings");
              },
              icon: const Icon(CupertinoIcons.settings_solid),
            ),
          ],
          title: const Text("Chats"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: NavigationBarCustom(context),
        ),
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
              return SafeArea(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    String user = currentUserId;
                    String otherUser = ds["users"]
                        .keys
                        .firstWhere((element) => element != user);
                    String chatRoomId = ds.id;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: InkWell(
                        onLongPress: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  actions: [
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        chatRoomId = ds.id;
                                        Navigator.pop(context);
                                        const ApiService().deleteChats(
                                          ds.id,
                                        );
                                      },
                                      child: const Text(
                                        "Delete Chat",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                );
                              });
                        },
                        splashColor: Colors.purple[100],
                        highlightColor: Colors.white,
                        focusColor: Colors.purple[100],
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Hero(
                                tag: ds["avatarUrl"],
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    ds["avatarUrl"],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(ds["name"]),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatPage(
                                  chatRoomID: chatRoomId,
                                  currentUserModel: user,
                                  messageUserModel: otherUser,
                                  name: ds["name"],
                                  senderImage: ds["avatarUrl"],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        height: 1,
                      ),
                    );
                  },
                ),
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
