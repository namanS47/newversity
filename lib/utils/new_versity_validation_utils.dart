import 'package:flutter/material.dart';

class ValidationUtils {

  //     ======================= Regular Expressions =======================     //
  static const String emailRegExp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegExp = r"^([234789]{1})([0-9]{8})$";
  static const String nameRegExp = r'^[a-zA-Z]+$';
  static const String classRegExpression = r'^([1-9]{2})$';
  static const String passwordRegexp = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{0,}$";


  //     ======================= Validation methods =======================     //
  static bool validateEmptyController(TextEditingController textEditingController) {
    return textEditingController.text.trim().isEmpty;
  }

  static bool validateOtp(TextEditingController textEditingController){
    return textEditingController.text.trim().length == 6;
  }

  static bool lengthValidator(TextEditingController textEditingController, int length) {
    return textEditingController.text.trim().length < length;
  }

  static bool regexValidator(TextEditingController textEditingController, String regex) {
    return RegExp(regex).hasMatch(textEditingController.text);
  }

  static bool compareValidator(TextEditingController textEditingController, TextEditingController secondController) {
    return textEditingController.text != secondController.text;
  }
}