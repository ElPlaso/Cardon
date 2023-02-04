import 'package:flutter/widgets.dart';
import 'package:cardonapp/app/general/eval.dart';
import 'package:cardonapp/home/home.dart';
import 'package:cardonapp/sign_in/login.dart';

/// Class for mapping routes to their respective pages.
class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/home': (context) => const Home(),
    '/login': (context) => const Login(),
    '/eval': (context) => const Eval(),
  };
}
