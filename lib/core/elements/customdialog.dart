import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    this.title,
    this.content
  }) : super(key: key);

  final String? title;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.5.h),
      contentPadding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 2.h),
      title: Text(title ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
        fontFamily: 'SourceSansPro',
        fontSize: 15.sp,
        fontWeight: FontWeight.bold
      ),
      ),
      content: content,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
    );
  }
}
