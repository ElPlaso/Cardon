import 'dart:async';

import 'package:cardonapp/sign_in/widgets/sign_up_widget.dart';
import 'package:flutter/material.dart';

/// Page that allows users to sign in.

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool _headingVisible = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _headingVisible = true;
      });
    });
  }

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
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: _headingVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 5),
                // The green box must be a child of the AnimatedOpacity widget.
                child: Padding(
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
              ),
              const Spacer(),
              const SignUpWidget(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      );
}
