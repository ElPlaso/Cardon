import 'package:cardonapp/app/widgets/home_banner.dart';
import 'package:cardonapp/main.dart';
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
        appBar: AppBar(
          title: const Text(MyApp.title),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              HomeBanner(subheading: 'Sign in below :)'),
              SignUpWidget()
            ],
          ),
        ),
      );
}
