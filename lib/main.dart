import 'package:cardonapp/firebase_options.dart';
import 'package:cardonapp/providers/card_provider.dart';
import 'package:cardonapp/providers/cardcreator_provider.dart';
import 'package:cardonapp/providers/query_provider.dart';
import 'package:cardonapp/widgets/google_sign_in.dart';
import 'package:cardonapp/widgets/navigate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// * The App

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// * Init global providers, that will be used throughout the app.
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CardCreator()),
    ChangeNotifierProvider(create: (_) => QueryProvider()),
    ChangeNotifierProvider(create: (_) => Cards()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  static const String title = 'QRCards';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primaryColor: Colors.blue),
        // * On entry to the app. This Navigates the user to
        // * - the evaluation component
        initialRoute: '/eval',
        routes: Navigate.routes,
      ));
}
