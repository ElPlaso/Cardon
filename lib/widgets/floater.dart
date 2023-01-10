import 'package:flutter/material.dart';

// * Floating action button

class Floater extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Icon icon;

  const Floater({
    required this.text,
    required this.onClicked,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: onClicked,
        icon: icon,
        label: Text(text),
      ));
}
