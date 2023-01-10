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

    return ToggleButtons(
      color: Colors.black.withOpacity(0.60),
      selectedColor: Colors.blue,
      selectedBorderColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.08),
      splashColor: Colors.blue.withOpacity(0.12),
      hoverColor: Colors.blue.withOpacity(0.04),
      borderRadius: BorderRadius.circular(4.0),
      isSelected: isSelected,
      highlightColor: Colors.transparent,
      onPressed: (int index) {
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
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('NIMBUS'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('EGGSHELL'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('OFF-WHITE'),
        ),
      ],
    );
  }
}
