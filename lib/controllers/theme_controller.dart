import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../utils/new_versity_assets.dart';
import '../utils/new_versity_color_constant.dart';

class ThemeController {
  bool isDarkMode = false;
  ThemeData? selectedThemeData;

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    dividerColor: FlutterDemoColorConstant.appLightBlack,
    scaffoldBackgroundColor: FlutterDemoColorConstant.appWhite,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: FlutterDemoColorConstant.appWhite,
      ),
      headline2: TextStyle(
        color: FlutterDemoColorConstant.appBlack,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      headline3: TextStyle(
        color: FlutterDemoColorConstant.appBlack,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      headline4: TextStyle(
        color: FlutterDemoColorConstant.appBlack,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      headline5: TextStyle(
        color: FlutterDemoColorConstant.appBlack,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      subtitle1: TextStyle(
        color: FlutterDemoColorConstant.appBlack,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        color: FlutterDemoColorConstant.appLightBlack,
        fontWeight: FontWeight.w600,
        fontSize: 9,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        shadowColor:
        MaterialStateProperty.all(FlutterDemoColorConstant.appTransparent),
      ),
    ),
    splashFactory: NoSplash.splashFactory,
    drawerTheme: const DrawerThemeData(
        backgroundColor: FlutterDemoColorConstant.appWhite),
    iconTheme:
    const IconThemeData(color: FlutterDemoColorConstant.appWhite, size: 20),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: FlutterDemoAssets.defaultFont,
    dividerColor: FlutterDemoColorConstant.appWhite,
    scaffoldBackgroundColor: FlutterDemoColorConstant.appBlack,
    textTheme: TextTheme(
      headline1: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: FlutterDemoColorConstant.appWhite,
      ),
      headline2: const TextStyle(
        color: FlutterDemoColorConstant.appWhite,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      headline3: const TextStyle(
        color: FlutterDemoColorConstant.appWhite,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      headline4: const TextStyle(
        color: FlutterDemoColorConstant.appWhite,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      headline5: const TextStyle(
        color: FlutterDemoColorConstant.appWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      subtitle1: const TextStyle(
        color: FlutterDemoColorConstant.appWhite,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        color: FlutterDemoColorConstant.appWhite.withOpacity(0.8),
        fontWeight: FontWeight.w700,
        fontSize: 9,
      ),
    ),
    splashFactory: NoSplash.splashFactory,
    drawerTheme: const DrawerThemeData(
        backgroundColor: FlutterDemoColorConstant.appLightBlack),
    iconTheme:
    const IconThemeData(color: FlutterDemoColorConstant.appWhite, size: 20),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor:
        MaterialStateProperty.all(FlutterDemoColorConstant.appRed),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        shadowColor:
        MaterialStateProperty.all(FlutterDemoColorConstant.appTransparent),
      ),
    ),
  );

  ThemeController() {
    Brightness brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    selectedThemeData = isDarkMode ? darkTheme : lightTheme;
    checkTheme();
  }

  void swapTheme({Brightness? brightness}) async {
    if (brightness == null) {
      selectedThemeData =
      selectedThemeData == lightTheme ? darkTheme : lightTheme;
    } else {
      isDarkMode = brightness == Brightness.dark;
      selectedThemeData = isDarkMode ? darkTheme : lightTheme;
    }
    isDarkMode = selectedThemeData == lightTheme ? false : true;
  }

  void checkTheme() async {
    // if (await checkPrefKey(isTheme)) {
    //   isDarkMode = (await getPrefBoolValue(isTheme))!;
    //   selectedThemeData = isDarkMode ? darkTheme : lightTheme;
    //   notifyListeners();
    // }
  }
}
