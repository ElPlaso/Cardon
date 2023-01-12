import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cardcreator_provider.dart';

// Row of radio button to toggle card theme

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({
    super.key,
  });

  @override
  ThemeToggleState createState() {
    return ThemeToggleState();
  }
}

class ThemeToggleState extends State<ThemeToggle> {
  final isSelected = <bool>[false, false, false];
  final colors = [
    const Color.fromARGB(255, 29, 29, 29),
    const Color.fromARGB(255, 240, 234, 214),
    const Color.fromARGB(255, 255, 255, 255)
  ];

  @override
  Widget build(BuildContext context) {
    String theme = context.read<CardCreator>().theme;

    switch (theme) {
      case 'eggshell':
        {
          isSelected[1] = true;
        }
        break;
      case 'off-white':
        {
          isSelected[2] = true;
        }
        break;
      default:
        {
          isSelected[0] = true;
        }
    }

    return Ink(
      width: 300,
      height: 50,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        primary: true,
        crossAxisCount: 3, //set the number of buttons in a row
        crossAxisSpacing: 8, //set the spacing between the buttons
        childAspectRatio: 2, //set the width-to-height ratio of the button,
        children: List.generate(
          isSelected.length,
          (index) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
                switch (index) {
                  case 1:
                    {
                      context.read<CardCreator>().setTheme('eggshell');
                    }
                    break;
                  case 2:
                    {
                      context.read<CardCreator>().setTheme('off-white');
                    }
                    break;
                  default:
                    {
                      context.read<CardCreator>().setTheme('nimbus');
                    }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: colors[index],
                elevation: isSelected[index] ? 15 : 1,
              ),
              child: null,
            );
          },
        ),
      ),
    );
  }
}
