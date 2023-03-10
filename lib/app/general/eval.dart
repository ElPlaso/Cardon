import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/home/home.dart';
import 'package:cardonapp/sign_in/login.dart';
import 'package:cardonapp/app/providers/query_provider.dart';

/// Widget which builds either the [Login] or [Home] page.
///
/// It evaluates wether user is logged in or not,
/// queries Firebase auth for current authentication status of user,
/// and then redirects the user to the login page
/// or home page accordingly.
class Eval extends StatefulWidget {
  const Eval({super.key});

  @override
  EvalState createState() => EvalState();
}

class EvalState extends State<Eval> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => Scaffold(
        key: scaffoldKey,
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('something went wrong'),
              );
            } else if (snapshot.hasData) {
              context.read<QueryProvider>().setUserId(snapshot.data!.uid);

              return const Home();
            } else {
              context.read<QueryProvider>().setUserId('');
              return const Login();
            }
          },
        ),
      );
}
