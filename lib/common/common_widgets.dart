import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      decoration: widget.decoration ?? InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 12),
        isDense: widget.isDense,
        errorText: widget.errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
        // focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.redAccent)),
        // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.redAccent)),
        // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
      ),
    );
  }
}

class CommonWidgets {
  static Container getRoundedBoxWithText({bool isSelected = false, Color? selectedColor, Color? color, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          color: isSelected?  selectedColor ?? Colors.grey : color ?? Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Text(text),
    );
  }

  // static Widget getAppCta() {
  //
  // }
}
