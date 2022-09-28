import 'package:chat_application/core/elements/customColor.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.ontap,
    required this.buttontext
  }) : super(key: key);

  final VoidCallback ontap;
  final String buttontext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            onPressed: ontap,
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.buttoncolor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            child: Text(buttontext,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20
              ),
            ))
    );
  }
}
