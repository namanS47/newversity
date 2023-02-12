import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'new_versity_assets.dart';
import 'new_versity_color_constant.dart';
import 'new_versity_image_asset.dart';


class PlumTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String hint;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final bool isBorder;
  final bool isDecoration;

  const PlumTextFormField(
      {Key? key,
        this.controller,
        this.textInputAction = TextInputAction.next,
        this.keyboardType = TextInputType.name,
        this.prefixIcon,
        this.onTap,
        this.onChanged,
        this.onSubmitted,
        this.readOnly = false,
        required this.hint,
        this.inputFormatters,
        this.fontSize,
        this.isBorder = true,
        this.isDecoration = true,
        this.focusNode})
      : super(key: key);
  final FocusNode? focusNode;

  final fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      onChanged: onChanged,
      readOnly: readOnly,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: FlutterDemoColorConstant.lightGreyColor,
      cursorWidth: 1,
      inputFormatters: inputFormatters,
      style: Theme.of(context).textTheme.headline3!.copyWith(
          fontSize: fontSize ?? 14.px, color: FlutterDemoColorConstant.lightGreyColor),
      decoration: isDecoration
          ? InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
            fontSize: fontSize ?? 14.px,
            fontWeight: FontWeight.w500,
            color: FlutterDemoColorConstant.lightGreyColor),
        filled: true,
        prefixIcon: prefixIcon,
        fillColor: isDecoration
            ? FlutterDemoColorConstant.appWhite
            : Colors.transparent,
        prefixIconConstraints:
        BoxConstraints(minWidth: 40.px, maxHeight: 23.px),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: isBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: FlutterDemoColorConstant.textFieldBorderColor
                  .withOpacity(0.5)),
        )
            : InputBorder.none,
        disabledBorder: isBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: FlutterDemoColorConstant.textFieldBorderColor
                  .withOpacity(0.5)),
        )
            : InputBorder.none,
        enabledBorder: isBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: FlutterDemoColorConstant.textFieldBorderColor
                  .withOpacity(0.5)),
        )
            : InputBorder.none,
        errorBorder: isBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: FlutterDemoColorConstant.textFieldBorderColor
                  .withOpacity(0.5)),
        )
            : InputBorder.none,
        focusedBorder: isBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: FlutterDemoColorConstant.textFieldBorderColor
                  .withOpacity(0.5)),
        )
            : InputBorder.none,
      )
          : InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              fontSize: fontSize ?? 14.px,
              fontWeight: FontWeight.w500,
              color: FlutterDemoColorConstant.lightGreyColor),
          border: InputBorder.none),
    );
  }
}

class RoundedTextFormField extends StatelessWidget {
  final GestureTapCallback? onTap;
  final double? radius;
  final double? height;
  final double? width;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool isNumber;
  final bool showSuffix;
  final bool obscureText;
  final int length;
  final GestureTapCallback? onSuffixTap;

  const RoundedTextFormField({
    Key? key,
    this.onTap,
    this.radius,
    this.prefixIcon,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.height= 46,
    this.width = 296,
    this.readOnly = false,
    this.isNumber = false,
    this.showSuffix = false,
    this.obscureText = false,
    this.length = 10,
    this.onSuffixTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height!.px,
      width: 296.px,
      padding: EdgeInsets.symmetric(horizontal: 12.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8.px),
        color: FlutterDemoColorConstant.appSuggestionBorder,
      ),
      child: Row(
        children: [
          if (prefixIcon != null) SizedBox(width: 66.px, child: prefixIcon),
          Expanded(
            child: TextFormField(
              onTap: onTap,
              controller: controller,
              style: TextStyle(
                fontFamily: FlutterDemoAssets.defaultFont,
                fontSize: 14.px,
                fontWeight: FontWeight.w600,
                color: FlutterDemoColorConstant.appBlue,
              ),
              readOnly: readOnly,
              obscureText: obscureText,
              keyboardType: keyboardType,
              cursorColor: FlutterDemoColorConstant.appBlue,
              inputFormatters: [
                if (isNumber) FilteringTextInputFormatter.digitsOnly,
                if (isNumber) LengthLimitingTextInputFormatter(length),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: FlutterDemoAssets.defaultFont,
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                  color: FlutterDemoColorConstant.purpleGreyColor,
                ),
              ),
            ),
          ),
          if (showSuffix)
            InkWell(
              onTap: onSuffixTap,
              child: Container(
                height: 46.px,
                padding: EdgeInsets.only(left: 10.px),
                child: FlutterDemoImageAsset(
                  image: !obscureText
                      ? FlutterDemoAssets.icNotShowPass
                      : FlutterDemoAssets.icShowPass,
                  height: 12.px,
                  width: 16.px,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
