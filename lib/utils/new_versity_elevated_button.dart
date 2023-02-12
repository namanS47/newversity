import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'new_versity_color_constant.dart';
import 'new_versity_text.dart';

class FlutterDemoElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final String buttonName;
  final double? fontSize;
  final Color fontColor;
  final double? buttonRadius;
  final Color buttonColor;
  final double? buttonHeight;
  final double buttonWidth;
  final bool isBorderShape;

  const FlutterDemoElevatedButton(
      {Key? key,
        this.onPressed,
        this.padding = EdgeInsets.zero,
        required this.buttonName,
        this.fontSize,
        this.fontColor = FlutterDemoColorConstant.appWhite,
        this.buttonRadius,
        this.buttonColor = FlutterDemoColorConstant.appPurple,
        this.buttonHeight,
        this.buttonWidth = double.infinity,
        this.isBorderShape = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: buttonHeight ?? 48.px,
        width: buttonWidth,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: isBorderShape
                ? MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonRadius??5.px), side: BorderSide(color: buttonColor)))
                : MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonRadius ?? 5.px),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(isBorderShape ? FlutterDemoColorConstant.appWhite : buttonColor),
          ),
          child: FlutterDemoText(
            buttonName,
            fontSize: fontSize,
            color: isBorderShape ? buttonColor : fontColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
