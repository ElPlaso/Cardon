import 'package:flutter/material.dart';

/// A navigational menu button which displays a count of items.
///
/// For example:
/// It can be used to navigate to a page that holds a list of cards.
/// The count in this case would be the number of cards on the page /
/// in the list.

class MenuButton extends StatelessWidget {
  final String text;
  final int count;
  final VoidCallback onClicked;
  final Icon icon;
  const MenuButton({
    required this.text,
    required this.onClicked,
    required this.icon,
    required this.count,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  Text(count.toString()),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            icon: icon,
          ),
        ),
      );
}
