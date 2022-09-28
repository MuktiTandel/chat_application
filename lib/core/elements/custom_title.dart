import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    Key? key,
    required this.title
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
        title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 20.sp,
        fontFamily: 'SourceSansPro'
      ),
    );
  }
}
