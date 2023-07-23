import 'package:chats/presentation/screens/chat/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/data_fetch/api_service.dart';
import '../../widgets/nav_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

TextEditingController searchController = TextEditingController();

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: NavigationBarCustom(context),
      ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) {
                setState(() {});
              },
              controller: searchController,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              initialData: const ApiService()
                  .getChatRooms(FirebaseAuth.instance.currentUser!.uid),
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where(
                    "name",
                    isGreaterThanOrEqualTo: searchController.text.trim(),
                    isLessThanOrEqualTo: '${searchController.text}\uf8ff',
                    isNotEqualTo:
                        FirebaseAuth.instance.currentUser!.displayName,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CupertinoActivityIndicator.partiallyRevealed();
                }
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapShot = snapshot.data as QuerySnapshot;
                  if (dataSnapShot.docs.isNotEmpty) {
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: dataSnapShot.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = dataSnapShot.docs[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InkWell(
                            onTap: () async {
                              //Check if they already have an ChatRoom Associated
                              //If they do, navigate to the chat room
                              //If they don't, create a new chat room and navigate to the chat room
                              final String chatRoomID = await const ApiService()
                                  .getChatRoomID(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      ds.id);
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      chatRoomID: chatRoomID,
                                      currentUserModel: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      messageUserModel: ds.id,
                                      name: ds["name"],
                                      senderImage: ds["avatarUrl"],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    ds["avatarUrl"],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ds["name"],
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    );
                  }
                  if (dataSnapShot.docs.length < 1) {
                    print("No users found");
                    return const Center(
                      child: Column(
                        children: [
                          Text("No users found"),
                          Text("Case Sensitive"),
                        ],
                      ),
                    );
                  }
                }
                return const Center(
                  child: Column(
                    children: [
                      Text("No users found"),
                      Text("Please try again later"),
                    ],
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
