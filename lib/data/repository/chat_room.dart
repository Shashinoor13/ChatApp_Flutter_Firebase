import '../../data_state/data_state.dart';
import '../data_fetch/api_service.dart';
import '../model/chats.dart';
import '../model/user.dart';

class ChatRepository {
  final ApiService apiService;

  ChatRepository({required this.apiService});

  Stream getChatRooms(String userID) async* {
    try {
      final chatRooms = await apiService.getChatRooms(userID);
      print(chatRooms);
      yield* chatRooms;
    } catch (e) {
      DataError(e.toString());
    }
  }

  Stream getChatRoomMessages(String user1, String user2) async* {
    try {
      final chatRoomId = await apiService.getChatRoomID(user1, user2);
      final chatRoomMessages = apiService.getChatRoomMessages(chatRoomId);
      yield* chatRoomMessages;
    } catch (e) {
      DataError(e.toString());
    }
  }

  sendMessage(Chats message, String chatRoomId) async {
    if (message.message.isEmpty) return;
    await apiService.sendMessage(message, chatRoomId);
  }

  deleteChatRoomMessage(chatRoomId, id) {
    apiService.deleteChatRoomMessage(chatRoomId, id);
  }

  createNewUser(User newUser) async {
    //Further Validations and Modifications
    await apiService.createUser(newUser);
  }
}
