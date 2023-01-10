import 'package:flutter/widgets.dart';
import 'package:cardonapp/pages/eval.dart';
import 'package:cardonapp/pages/home.dart';
import 'package:cardonapp/pages/login.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/home': (context) => const Home(),
    '/login': (context) => const Login(),
    '/eval': (context) => const Eval(),
  };
}
