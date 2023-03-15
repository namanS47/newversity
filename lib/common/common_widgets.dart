import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/colors.dart';
import '../themes/strings.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    Key? key,
    this.textEditingController,
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
  }) : super(key: key);

  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final String? hintText;
  final String? errorText;
  final bool? isDense;
  final int? maxLines;
  final Function? onChange;
  final TextStyle? hintTextStyle;
  final Color? fillColor;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = widget.textEditingController ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formatters = widget.inputFormatters ?? [];

    return TextFormField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      inputFormatters: formatters,
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
            filled: true,
            fillColor: widget.fillColor ?? AppColors.grey35,
            hintText: widget.hintText,
            hintStyle: widget.hintTextStyle ??
                const TextStyle(
                    fontSize: 14,
                    color: AppColors.blackRussian,
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

class AppCta extends StatelessWidget {
  const AppCta({Key? key, this.onTap, this.text = "", this.isLoading = false})
      : super(key: key);

  final void Function()? onTap;
  final bool isLoading;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: GestureDetector(
        onTap: !isLoading ? onTap : null,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.cyanBlue,
          ),
          child: !isLoading
              ? Center(
                  child: Text(
                    text ?? "",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                )
              : CommonWidgets.getCircularProgressIndicator(),
        ),
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
}
