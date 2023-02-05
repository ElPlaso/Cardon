import 'package:flutter/material.dart';

/// A simple button to be used in a list / column.
///
/// Used to signal actions, in a page where multiple actions can be performed.
/// Its relating icon is displayed on the right.

class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final IconData iconData;
  final Color? color;

  const SmallButton({
    Key? key,
    required this.text,
    required this.onClicked,
    this.color,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 15.0),
        child: SizedBox(
          width: 250,
          height: 50,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: OutlinedButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: onClicked,
              label: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    color: color ?? Colors.blue,
                  ),
                ),
              ),
              icon: Icon(
                iconData,
                size: 25,
                color: color,
              ),
            ),
          ),
        ),
      );
}
