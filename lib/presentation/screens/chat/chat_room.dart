import 'dart:async';

import 'package:chats/data/data_fetch/api_service.dart';
import 'package:chats/data/model/chats.dart';
import 'package:chats/data/repository/chat_room.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String chatRoomID;
  final String currentUserModel;
  final String messageUserModel;
  final String senderImage;
  final String name;
  const ChatPage({
    super.key,
    required this.chatRoomID,
    required this.currentUserModel,
    required this.messageUserModel,
    required this.senderImage,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // final String chatRoomID = const ApiService()
    //     .getChatRoomID(currentUserModel.id, messageUserModel.id);
    bool isReplied = false;
    final visible = Visible();
    final messageController = TextEditingController();
    final searchController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    StreamBuilder(
                        stream:
                            const ApiService().getUserModel(messageUserModel),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CupertinoActivityIndicator();
                          }
                          if (snapshot.hasData) {
                            return Hero(
                              tag: senderImage,
                              child: CircleAvatar(
                                maxRadius: 20,
                                backgroundImage: NetworkImage(senderImage),
                              ),
                            );
                          }
                          return const CupertinoActivityIndicator();
                        }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {},
                            child: const Text('View Contact'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              visible.changeVisibility(true);
                              Navigator.pop(context);
                            },
                            child: const Text('Search'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {},
                            child: const Text('Mute Notifications'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {},
                            child: const Text(
                              'Block',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      );
                    });
              },
              icon: const Icon(CupertinoIcons.ellipsis_vertical),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Visibility(
                    visible: visible.isDisplayed,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                        // TODO: search
                        // onChanged: (value) {
                        //   List messages = [];
                        //   for (var i = 0; i < documents.length; i++) {
                        //     messages.add(documents[i]['message']);
                        //   }
                        //   for (var i = 0; i < messages.length; i++) {
                        //     if (messages[i].contains(value)) {
                        //       filtered.add(messages[i]);
                        //     }
                        //   }
                        // },
                        onSubmitted: (value) {
                          //Todo: search
                          visible.changeVisibility(false);
                        },
                        controller: searchController,
                        placeholder: 'Search',
                      ),
                    ),
                  ),
                );
              },
              stream: visible.visiblestream,
            ),
            Expanded(
              child: StreamBuilder(
                stream: ChatRepository(apiService: const ApiService())
                    .getChatRoomMessages(currentUserModel, messageUserModel),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data.docs[index];
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: null,
                            enableFeedback: false,
                            onLongPress: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () {},
                                          child: const Text('Reply'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {},
                                          child: const Text('Forward'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {},
                                          child: const Text('Star'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            ChatRepository(
                                                    apiService:
                                                        const ApiService())
                                                .deleteChatRoomMessage(
                                                    chatRoomID, data.id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            FlutterClipboard.copy(
                                                data['message']);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                backgroundColor: Colors.white,
                                                content: Text(
                                                    'Copied to Clipboard',
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            );
                                          },
                                          child: const Text('Copy'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {},
                                          child: const Text('Info'),
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    data['sender'] == currentUserModel
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            data['sender'] == currentUserModel
                                                ? Colors.blue
                                                : Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        data['message'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                bottom: 20,
                left: 10,
                right: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CupertinoTextField(
                        clipBehavior: Clip.antiAlias,
                        controller: messageController,
                        placeholder: 'Type a message',
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Chats message = Chats(
                        sender: currentUserModel,
                        message: messageController.text,
                        time: DateTime.now(),
                        isReplied: isReplied, //TODO:Implement Later
                      );
                      ChatRepository(apiService: const ApiService())
                          .sendMessage(message, chatRoomID);
                      messageController.clear();
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_up_circle_fill,
                      color: Colors.green,
                      size: 30,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Visible {
  bool isDisplayed = false;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  StreamSink<bool> get visiblesink => _controller.sink;
  Stream<bool> get visiblestream => _controller.stream;
  void changeVisibility(bool visible) {
    _controller.sink.add(visible);
  }

  void dispose() {
    _controller.close();
  }

  Visible() {
    visiblestream.listen((event) {
      if (event == true) {
        isDisplayed = true;
      }
      if (event == false) {
        isDisplayed = false;
      }
    });
  }
}

class Filtered {
  Set<Chats> filtered = {};
  final StreamController<Set> _controller = StreamController<Set>.broadcast();
  StreamSink<Set> get filteredsink => _controller.sink;
  Stream<Set> get filteredstream => _controller.stream;
}
