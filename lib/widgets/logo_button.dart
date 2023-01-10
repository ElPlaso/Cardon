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
          height: 70,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: OutlinedButton.icon(
              onPressed: onClicked,
              label: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              icon: icon,
            ),
          ),
        ),
      );
}
