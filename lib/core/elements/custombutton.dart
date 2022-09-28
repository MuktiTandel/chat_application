import 'package:chat_application/core/elements/customColor.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.ontap,
    required this.buttontext,
    this.height,
    this.borderRadius,
    this.backgroundColor
  }) : super(key: key);

  final VoidCallback ontap;
  final String buttontext;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            onPressed: ontap,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 10))
            ),
            child: Text(buttontext,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                fontFamily: 'SourceSansPro'
              ),
            ))
    );
  }
}
