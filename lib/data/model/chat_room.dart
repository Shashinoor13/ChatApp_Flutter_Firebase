import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String chatRoomId;
  final List<String> users;
  final String lastMessage;

  const ChatRoom(this.chatRoomId, this.users, this.lastMessage);

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      json['chatRoomId'],
      json['users'],
      json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'users': users,
      'lastMessage': lastMessage,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [chatRoomId, users, lastMessage];
}
