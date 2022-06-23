import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableLinkText extends StatefulWidget {
  final String text;

  ClickableLinkText({required this.text});

  @override
  _ClickableLinkTextState createState() => _ClickableLinkTextState();
}

class _ClickableLinkTextState extends State<ClickableLinkText> {

  bool isHovering = false;
  Color hoverColor = Colors.blue;
  Color defaultColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (e) {
          setState(() {
            isHovering = true;
          });
        },
        onExit: (e) {
          setState(() {
            isHovering = false;
          });
        },
        child: SelectableText.rich(
            TextSpan(
              text: widget.text,
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: isHovering? hoverColor : defaultColor),
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("Clicked forgot password.");
                },
            )
        ),
      );
  }

}