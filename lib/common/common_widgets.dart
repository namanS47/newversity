import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../flow/student/home/model/session_details.dart';
import '../resources/images.dart';
import '../themes/colors.dart';
import '../utils/date_time_utils.dart';

class AppDropdownButton extends StatelessWidget {
  final String hint;
  final String? value;
  final List<DropdownMenuItem<String>>? itemBuilder;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset? offset;

  const AppDropdownButton({
    required this.hint,
    required this.value,
    this.itemBuilder,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth = double.infinity,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: SizedBox(
        height: 42,
        child: DropdownButton2(
          isExpanded: true,
          hint: Container(
            alignment: hintAlignment,
            child: AppText(
              hint,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.grey50,
            ),
          ),
          value: value,
          items: itemBuilder ??
              dropdownItems
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Container(
                        width: double.infinity,
                        alignment: valueAlignment,
                        child: AppText(
                          item,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          fontSize: 14,
                          color: AppColors.blackMerlin,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          selectedItemBuilder: selectedItemBuilder,
          icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: icon ?? const Icon(Icons.expand_more),
          ),
          iconSize: iconSize ?? 22,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
          buttonHeight: buttonHeight ?? 50,
          buttonWidth: buttonWidth,
          buttonPadding: buttonPadding ?? EdgeInsets.zero,
          buttonDecoration: buttonDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
          buttonElevation: buttonElevation,
          itemHeight: itemHeight ?? 52,
          itemPadding:
              itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
          dropdownMaxHeight: dropdownHeight ?? 200,
          dropdownWidth: dropdownWidth ?? 290,
          dropdownPadding: dropdownPadding,
          dropdownDecoration: dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.whiteColor,
              ),
          dropdownElevation: dropdownElevation ?? 8,
          scrollbarRadius: scrollbarRadius ?? const Radius.circular(40),
          scrollbarThickness: scrollbarThickness,
          scrollbarAlwaysShow: scrollbarAlwaysShow,
          offset: offset,
          dropdownOverButton: false,
        ),
      ),
    );
  }
}

class AppAnimatedBottomSheet extends StatelessWidget {
  final bool showDivider;
  final Widget bottomSheetWidget;
  final Widget? bottomNavBarWidget;

  const AppAnimatedBottomSheet(
      {Key? key,
      required this.bottomSheetWidget,
      this.bottomNavBarWidget,
      this.showDivider = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: AppColors.whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDivider)
                const Divider(
                  color: AppColors.grey32,
                  thickness: 1,
                  height: 0,
                ),
              bottomSheetWidget,
              if (bottomNavBarWidget != null) bottomNavBarWidget!,
            ],
          ),
        ),
      ],
    );
  }
}

class NoResultFoundScreen extends StatelessWidget {
  const NoResultFoundScreen({Key? key, required this.message})
      : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        SvgPicture.asset(ImageAsset.nothingFoundIcon),
        const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 20),
          child: Text(
            "No result found",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class AppImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? webHeight;
  final double? width;
  final double? webWidth;
  final Color? color;
  final BoxFit? fit;
  final BoxFit? webFit;

  const AppImage({
    Key? key,
    required this.image,
    this.webFit,
    this.fit,
    this.height,
    this.webHeight,
    this.width,
    this.webWidth,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image.startsWith('http')
        ? CachedNetworkImage(
            imageUrl: image,
            height: webHeight,
            width: webWidth,
            fit: webFit ?? BoxFit.cover,
            placeholder: (context, url) =>
                CommonWidgets.getCircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
          )
        : !image.contains('.')
            ? Image.network(image,
        height: webHeight,
        width: webWidth,
        fit: webFit ?? BoxFit.cover, errorBuilder: (BuildContext context,
            Object exception, StackTrace? stackTrace) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: AppImage(
                image: ImageAsset.blueAvatar,
              ),
            ),
          );
        })
            : image.split('.').last != 'svg'
                ? Image.asset(
                    image,
                    fit: fit,
                    height: height,
                    width: width,
                    color: color,
                  )
                : SvgPicture.asset(
                    image,
                    height: height,
                    width: width,
                    color: color,
                  );
  }
}

class ShimmerEffectView extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const ShimmerEffectView(
      {Key? key, this.height, this.width, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.redColorShadow400,
      highlightColor: AppColors.primaryColor,
      child: Container(
        height: height ?? 30,
        width: width ?? 50,
        decoration: BoxDecoration(
          color: AppColors.redColorShadow400,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
      ),
    );
  }
}

class AppTextFormField extends StatefulWidget {
  const AppTextFormField(
      {Key? key,
      this.controller,
      this.keyboardType,
      this.inputFormatters,
      this.validator,
      this.decoration,
      this.hintText,
      this.errorText,
      this.isDense,
      this.maxLines,
      this.onChange,
      this.hintTextStyle,
      this.fillColor,
      this.autofocus,
      this.isEnable = true,
      this.contentPadding,
      this.textInputAction})
      : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final String? hintText;
  final String? errorText;
  final bool? isDense;
  final bool isEnable;
  final int? maxLines;
  final Function? onChange;
  final TextStyle? hintTextStyle;
  final Color? fillColor;
  final bool? autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formatters = widget.inputFormatters ?? [];

    return TextFormField(
      enabled: widget.isEnable,
      controller: _controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      inputFormatters: formatters,
      textCapitalization: TextCapitalization.words,
      autofocus: widget.autofocus ?? false,
      validator: widget.validator != null
          ? (value) {
              return widget.validator!(value);
            }
          : null,
      maxLines: widget.maxLines,
      onChanged: (v) {
        widget.onChange?.call(v);
      },
      decoration: widget.decoration ??
          InputDecoration(
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: widget.fillColor ?? AppColors.grey35
              ..withOpacity(0.83),
            hintText: widget.hintText,
            hintStyle: widget.hintTextStyle ??
                TextStyle(
                    fontSize: 14,
                    color: AppColors.grey50,
                    fontWeight: FontWeight.normal),
            isDense: widget.isDense,
            errorText: widget.errorText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.grey32),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.grey32),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.grey32),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.redAccent)),
          ),
    );
  }
}

class AppText extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;

  const AppText(
    this.title, {
    Key? key,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.fontSize,
    this.textAlign,
    this.height,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.decoration = TextDecoration.none,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? AppColors.blackMerlin,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize ?? 14,
        height: height,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

class RoundedTextFormField extends StatelessWidget {
  final GestureTapCallback? onTap;
  final double? radius;
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
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8),
        color: AppColors.grey35,
      ),
      child: Row(
        children: [
          if (prefixIcon != null) SizedBox(width: 66, child: prefixIcon),
          Expanded(
            child: TextFormField(
              onTap: onTap,
              controller: controller,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
              readOnly: readOnly,
              obscureText: obscureText,
              keyboardType: keyboardType,
              cursorColor: AppColors.primaryColor,
              inputFormatters: [
                if (isNumber) FilteringTextInputFormatter.digitsOnly,
                if (isNumber) LengthLimitingTextInputFormatter(length),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.cyanBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppCta extends StatelessWidget {
  const AppCta({
    Key? key,
    this.onTap,
    this.text = "",
    this.isLoading = false,
    this.padding,
    this.textColor,
    this.width,
    this.color,
    this.isEnable = true,
  }) : super(key: key);

  final void Function()? onTap;
  final bool isLoading;
  final String text;
  final double? width;
  final Color? color;
  final Color? textColor;
  final bool isEnable;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 24),
      child: GestureDetector(
        onTap: !isLoading ? onTap : null,
        child: Container(
          height: 50,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isEnable ? color ?? AppColors.cyanBlue : AppColors.grey32,
          ),
          child: !isLoading
              ? Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 16,
                        color: textColor ?? Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                )
              : CommonWidgets.getCircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ImagePickerOptionBottomSheet extends StatefulWidget {
  const ImagePickerOptionBottomSheet(
      {Key? key, required this.onCameraClick, required this.onGalleryClick})
      : super(key: key);

  final void Function() onCameraClick;
  final void Function() onGalleryClick;

  @override
  State<ImagePickerOptionBottomSheet> createState() =>
      _ImagePickerOptionBottomSheetState();
}

class _ImagePickerOptionBottomSheetState
    extends State<ImagePickerOptionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 150,
      // color: Colors.red,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onCameraClick,
                  child: const Text(
                    "Camera",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onGalleryClick,
                  child: const Text(
                    "Gallery",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CommonWidgets {
  static Container getRoundedBoxWithText(
      {bool isSelected = false,
      Color? selectedColor,
      Color? color,
      required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          color: isSelected
              ? selectedColor ?? Colors.grey
              : color ?? Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20)),
      child: Text(text),
    );
  }

  static Widget getCircularProgressIndicator() {
    return const Center(
      child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: AppColors.whiteColor,
            strokeWidth: 2,
          )),
    );
  }

  static snackBarWidget(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
        ),
      ),
    );
  }
}