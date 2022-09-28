import 'package:chat_application/core/elements/customColor.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';

class CustomRichtext extends StatelessWidget {
  const CustomRichtext({
    Key? key,
    required this.childtext,
    required this.title
  }) : super(key: key);

  final String title;
  final String childtext;

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
      text: title,
      style: TextStyle(
        color: Colors.black45,
        fontSize: 12.sp
      ),
      children: [
        TextSpan(
          text: childtext,
          style: TextStyle(
            color: CustomColor.primary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600
          )
        )
      ]
    ));
  }
}
