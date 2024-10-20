import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget customTextWithAction({
  required String mainText,
  required String actionText,
  required VoidCallback onTap,
  Color mainTextColor = Colors.black,
  Color actionTextColor = const Color(0xff8264de),
  FontWeight fontWeight = FontWeight.bold,
}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: mainText,
          style: TextStyle(
            color: mainTextColor,
            fontWeight: fontWeight,
          ),
        ),
        TextSpan(
          text: actionText,
          style: TextStyle(
            color: actionTextColor,
            fontWeight: fontWeight,
          ),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ],
    ),
  );
}
