import 'package:flutter/material.dart';
import 'package:newversity/themes/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Manrope",
    colorScheme: const ColorScheme.light(
      primary: AppColors.blackRussian,
      secondary: AppColors.blackMerlin,
    ),
  );
}
