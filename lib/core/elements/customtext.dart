import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    this.textAlign
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 12.sp,
        fontFamily: 'SourceSansPro'
      ),
    );
  }
}
