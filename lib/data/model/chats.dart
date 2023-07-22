import 'package:equatable/equatable.dart';

class Chats extends Equatable {
  final String sender;
  final String message;
  final DateTime time;
  final bool isReplied;

  const Chats({
    required this.isReplied,
    required this.sender,
    required this.message,
    required this.time,
  });

  factory Chats.fromJson(Map<String, dynamic> json) {
    return Chats(
      sender: json['name'],
      message: json['message'],
      time: json['time'],
      isReplied: json['isReplied'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'time': DateTime.now(),
      'isReplied': isReplied,
    };
  }

  @override
  List<Object?> get props => [sender, message, time, isReplied];
}
