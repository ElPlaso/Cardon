import 'package:flutter/material.dart';

// * Icon button that aligns icon to the right
// * Requires button text and icon

class LogoButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Icon icon;

  const LogoButton({
    required this.text,
    required this.onClicked,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 15.0),
        child: SizedBox(
          width: 300,
          height: 50,
          child: OutlinedButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            onPressed: onClicked,
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
            ),
            icon: icon,
          ),
        ),
      );
}
