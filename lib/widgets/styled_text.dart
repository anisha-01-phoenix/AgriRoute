import 'package:flutter/material.dart';

class Styled_Text extends StatelessWidget {
  final Icon? icon;
  final String text;
  final Color color;
  final double size;
  final FontWeight fontWeight;

  Styled_Text({
    this.icon,
    required this.text,
    required this.color,
    required this.size,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          SizedBox(width: 3),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: fontWeight,
            ),
          ),
        )

      ],
    );
  }
}
