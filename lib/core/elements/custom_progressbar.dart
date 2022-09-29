import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialog {

  final Widget? loadingWidget;
  final bool? dismissable;
  final Function? onDismiss;
  final double? blur;
  final Color? backgroundColor;
  final bool? useSafeArea;
  final Duration? animationDuration;

  bool _IsShowing = false;

  late ProgressDialogWidget progressDialogWidget;

  bool get IsShowing => _IsShowing;

  ProgressDialog({
    this.loadingWidget,
    this.dismissable = true,
    this.onDismiss,
    this.blur = 0,
    this.backgroundColor = const Color(0x99000000),
    this.useSafeArea = false,
    this.animationDuration = const Duration(milliseconds: 300)
  }){
    initProgress();
  }

  void initProgress(){
    progressDialogWidget = ProgressDialogWidget();
  }

  void show() async{
    if (!_IsShowing) {
      _IsShowing = true;
      if (progressDialogWidget == null) initProgress();
      await showDialog(
        useSafeArea: useSafeArea ?? false,
        context: Get.context!,
        barrierDismissible: dismissable ?? true,
        builder: (context) => progressDialogWidget,
        barrierColor: Colors.transparent,
      );
      _IsShowing = false;
    }
  }

  void hide() async{
    if(_IsShowing){
      _IsShowing = false;
      Get.back();
    }
  }
}

class ProgressDialogWidget extends StatelessWidget {
   ProgressDialogWidget({
    Key? key,
    this.animationDuration = const Duration(milliseconds: 300),
    this.loadingWidget,
    this.onDismiss,
    this.backgroundColor,
    this.dismissable,
     this.blur
  }) {
     loadingWidget = loadingWidget ?? Container(
       padding: const EdgeInsets.all(10.0),
       height: 100.0,
       width: 100.0,
       alignment: Alignment.center,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
         color: Colors.white,
       ),
       child: const CircularProgressIndicator(
         strokeWidth: 2,
       ),
     );
   }

  Widget? loadingWidget;
  final Function? onDismiss;
  final Color? backgroundColor;
  final bool? dismissable;
  final Duration? animationDuration;
  final double? blur;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DialogBackground extends StatelessWidget {
   DialogBackground({
    Key? key,
    this.color,
    this.blur,
    this.dismissable,
    this.onDismiss,
    this.animationDuration = const Duration(milliseconds: 300),
    this.dialog
  }){
     colorOpacity = color?.opacity;
   }

  final Widget? dialog;
  final bool? dismissable;
  final Function? onDismiss;
  final double? blur;
  final Color? color;
  final Duration? animationDuration;
  double? colorOpacity;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: animationDuration ?? Duration(milliseconds: 300),
        builder: (context, val, child){
          return Material(
            type: MaterialType.canvas,
            color: color?.withOpacity(val * colorOpacity!),
            child: WillPopScope(
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: dismissable ?? true
                            ? () {
                          if (onDismiss != null) {
                            onDismiss!();
                          }
                          Navigator.pop(context);
                        }
                            : () {},
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: val * blur!,
                            sigmaY: val * blur!,
                          ),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                    dialog!
                  ],
                ),
                onWillPop: () async{
                  if(dismissable ?? true){
                    if(onDismiss != null) onDismiss!();
                    Get.back();
                  }
                  return true;
                }
            ),
          );
        }
    );
  }
}



