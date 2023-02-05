import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/app/providers/google_sign_in_provider.dart';

/// Button that allows users to sign in via Google.
class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('Sign in with Google'),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
            )
          ],
        ),
      );
}
