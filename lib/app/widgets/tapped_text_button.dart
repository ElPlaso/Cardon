import 'package:flutter/material.dart';

typedef TappedFunction = void Function();

/// A Text Button that changes its Text and Icon opacity on pressed/unpressed.
class TappedTextButton extends StatefulWidget {
  final String text;
  final IconData? iconData;
  final TappedFunction? onTap;
  final TextDirection? textDirection;
  const TappedTextButton({
    super.key,
    required this.text,
    this.iconData,
    required this.onTap,
    this.textDirection,
  });
  @override
  State<StatefulWidget> createState() => TappedTextButtonState();
}

class TappedTextButtonState extends State<TappedTextButton> {
  bool _tappedDown = false;

  void _tapAction() {
    setState(() {
      _tappedDown = !_tappedDown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      onTapDown: (_) {
        _tapAction();
      },
      onTapUp: (_) {
        _tapAction();
      },
      onTapCancel: () {
        _tapAction();
      },
      onTap: widget.onTap,
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
                  color: _tappedDown
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.75)
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                color: _tappedDown
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
