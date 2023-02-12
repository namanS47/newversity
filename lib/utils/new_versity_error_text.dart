import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'new_versity_color_constant.dart';
import 'new_versity_text.dart';

class ErrorText extends StatelessWidget {
  final String errorText;

  const ErrorText({Key? key,required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.px),
      child: FlutterDemoText(
        errorText,
        color: FlutterDemoColorConstant.appRed,
        fontSize: 14.px,
        fontWeight: FontWeight.w400,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}