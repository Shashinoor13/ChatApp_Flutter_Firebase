import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String name;
  final Map<String, bool> users;
  final String avatarUrl;

  const ChatRoom(
      {required this.name, required this.users, required this.avatarUrl});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      name: json['name'],
      users: json['users'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'users': users,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [name, users, avatarUrl];
}
