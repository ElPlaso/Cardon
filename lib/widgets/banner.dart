import 'package:flutter/material.dart';

// * Banner to welcome users to app
// * Requires subheading String

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
              stops: [
                0.3,
                1
              ],
              colors: [
                Colors.blueAccent,
                Colors.lightBlue,
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Welcome to Cardon!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
            Text(subheading,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
