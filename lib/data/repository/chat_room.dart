import '../../data_state/data_state.dart';
import '../data_fetch/api_service.dart';
import '../model/chat_room.dart';
import '../model/chats.dart';

class ChatRepository {
  final ApiService apiService;

  ChatRepository({required this.apiService});

  Future<DataState<List<ChatRoom>>> getChatRooms() async {
    try {
      const userID = "shashi"; //will change later
      final chatRooms = await apiService.getChatRooms(userID);
      return DataSuccess(chatRooms);
    } catch (e) {
      return DataError(e.toString());
    }
  }

  Stream getChatRoomMessages() async* {
    try {
      String user1 = 'shashi';
      String user2 = 'hello';
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
}
