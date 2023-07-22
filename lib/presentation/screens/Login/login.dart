import 'package:flutter/material.dart';

import '../../../auth/google_sign_in.dart';
import '../home/home_page.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await AuthProvider().signInWithGoogle();
            if (user != null) {
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }
            }
          },
          child: const Text("Sign in With Google"),
        ),
      ),
    );
  }
}
