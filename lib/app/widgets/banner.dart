import 'package:flutter/material.dart';

/// A widget which welcomes users to the app.
///
/// This widget can be customized with a given subheading.
class HomeBanner extends StatelessWidget {
  final String subheading;

  const HomeBanner({super.key, required this.subheading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Cardon!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subheading,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
