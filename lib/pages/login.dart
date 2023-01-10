import 'package:flutter/material.dart';
import 'package:cardonapp/widgets/sign_up_widget.dart';
import '../main.dart';
import '../widgets/banner.dart';

// * Login page

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
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
