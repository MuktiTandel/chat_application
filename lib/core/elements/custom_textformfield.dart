import 'package:chat_application/core/elements/customColor.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
  const CustomTextformfield({
    Key? key,
    this.border_radius,
    this.prefixicon,
    this.prefixiconColor,
    this.suffixWidget,
    this.hinttext,
    this.errortext,
    required this.controller,
    Function(String val)? validator,
    Function(String val)? onchange,
    this.isObscure = false,
    this.focusBorderColor,
    this.cursorColor,
    this.prefixWidget,
    this.maxline
  }) : _validator = validator,
      _onchange = onchange,
        super(key: key);

  final double? border_radius;
  final IconData? prefixicon;
  final Color? prefixiconColor;
  final Widget? suffixWidget;
  final String? hinttext;
  final String? errortext;
  final Function(String val)? _validator;
  final TextEditingController controller;
  final bool? isObscure;
  final Function(String val)? _onchange;
  final Color? focusBorderColor;
  final Color? cursorColor;
  final Widget? prefixWidget;
  final int? maxline;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure ?? false,
      cursorColor: cursorColor ?? Colors.black,
      minLines: 1,
      maxLines: maxline ?? 10,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(border_radius ?? 10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusBorderColor ?? Colors.black),
          borderRadius: BorderRadius.circular(border_radius ?? 10)
        ),
        prefixIcon: prefixWidget ?? Icon(prefixicon, color: prefixiconColor,),
        suffixIcon: suffixWidget,
        hintText: hinttext,
        errorText: errortext
      ),
      validator: (val) => _validator!(val!),
      onChanged: (val) => _onchange ?? {},
    );
  }
}
