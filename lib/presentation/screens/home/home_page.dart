import 'package:chats/data/model/user.dart';
import 'package:flutter/material.dart';

import '../chat/chat_room.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(
                  chatRoomID: 'xDKhqcwZbxeo5Rj59Lvy',
                  currentUserModel: User(
                    name: 'Shashinoor Ghimire',
                    email: 'shashinoorghimire13@gmail.co,',
                    avatarUrl:
                        'https://fastly.picsum.photos/id/727/200/300.jpg?hmac=YAlAwltwjf1ivXTPLvMU4JLzPsOLmXi9_O1aoYF7hcg',
                    id: 'shashi',
                  ),
                  messageUserModel: User(
                    name: 'Jon Doe',
                    email: 'jonDoe@gmail.com',
                    avatarUrl: 'https://picsum.photos/id/237/200/300',
                    id: 'hello',
                  ),
                ),
              ),
            );
          },
          child: const Text("Click To view Messages"),
        ),
      ),
    );
  }
}
