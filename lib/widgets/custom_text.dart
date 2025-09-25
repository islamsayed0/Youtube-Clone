import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 10,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  /// ******************** build ****************
  /// Purpose     : Render a custom styled text widget.
  /// Description : Displays a single line of text with customizable
  ///               color, font size, and font weight. If the text
  ///               is too long, it will be truncated with ellipsis (...).
  /// Usage       : Use `CustomText(text: "Hello", fontSize: 16, color: Colors.red)`
  ///               inside any widget tree to display styled text.
  /// Author      : Islam Sayed
  ///*****************************************************
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
