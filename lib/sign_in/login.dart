import 'package:cardonapp/sign_in/widgets/sign_up_widget.dart';
import 'package:flutter/material.dart';

/// Page that allows users to sign in.

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => Scaffold(
        key: scaffoldKey,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.3, 1],
              colors: [
                Colors.blueAccent,
                Colors.lightBlue,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 100),
                child: Text(
                  'Welcome to \nCardon.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              const SignUpWidget(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      );
}
