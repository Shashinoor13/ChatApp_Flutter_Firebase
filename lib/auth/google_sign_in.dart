import 'package:chats/data/model/user.dart' as local;
import 'package:chats/data/repository/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/data_fetch/api_service.dart';

class AuthProvider {
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    if (user.additionalUserInfo!.isNewUser) {
      final newUser = local.User(
        name: user.user!.displayName!,
        email: user.user!.email!,
        avatarUrl: user.user!.photoURL!,
        id: user.user!.uid,
      );

      ChatRepository(apiService: const ApiService()).createNewUser(newUser);
    }
    return user;
  }

  AuthProvider();
}
