import 'package:flutter/material.dart';

/// A Text Button that changes its Text and Icon opacity on pressed/unpressed.
class TappedTextButton extends StatefulWidget {
  final String text;
  final IconData? iconData;
  final Function onTap;
  final TextDirection? textDirection;
  const TappedTextButton(
      {super.key,
      required this.text,
      this.iconData,
      required this.onTap,
      this.textDirection});
  @override
  State<StatefulWidget> createState() => TappedTextButtonState();
}

class TappedTextButtonState extends State<TappedTextButton> {
  bool tappedDown = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      onTapDown: (_) {
        setState(() {
          tappedDown = !tappedDown;
        });
      },
      onTapUp: (_) {
        setState(() {
          tappedDown = !tappedDown;
        });
      },
      onTapCancel: () {
        setState(() {
          tappedDown = !tappedDown;
        });
      },
      onTap: () {
        widget.onTap();
      },
      child: Directionality(
        textDirection: widget.textDirection != null
            ? widget.textDirection!
            : TextDirection.ltr,
        child: Row(
          children: [
            if (widget.iconData != null)
              Padding(
                padding: widget.textDirection == TextDirection.rtl
                    ? const EdgeInsets.only(left: 5)
                    : const EdgeInsets.only(right: 5),
                child: Icon(
                  widget.iconData,
                  size: 25,
                  color: tappedDown
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.75)
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                color: tappedDown
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.75)
                    : Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
