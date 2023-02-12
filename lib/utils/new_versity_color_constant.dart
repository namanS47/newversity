import 'package:flutter/material.dart';

class FlutterDemoColorConstant {
  static const Color appScaffold = Color(0xFFD8D6D9);
  static const Color appStatusColor = Color(0xFFD9ED92);
  static const Color appPrimaryColor = Color(0xFF168AAD);
  static const Color appTransparent = Color(0x00000000);
  static const Color appWhite = Color(0xffFFFFFF);
  static const Color appBlack = Color(0xFF000000);
  static const Color appLightBlack = Color(0xFF9A9A9A);
  static const Color appRed = Color(0xFFC62828);
  static const Color appGreen = Color(0xFF2E9714);
  static const Color appLightGreen = Color(0xFF05A687);
  static const Color lightGreyColor = Color(0xff666C89);
  static const Color lightGreenColor = Color(0xffF8FDFF);
  static const Color lightGreyIndicator = Color(0xff8D8595);
  static const textDarkColor = Color(0xff172B4D);
  static const textFieldBorderColor = Color(0xff868686);
  static const Color chipColor = Color(0xffB6B6B6);
  static const chipDarkTextColor = Color(0xff5D0D8B);
  static const categoryBorderTextColor = Color(0xffE3CAFB);
  static const categoryBG1Color = Color(0xff95A047);
  static const categoryBG2Color = Color(0xffF0516D);
  static const categoryBG3Color = Color(0xff40A164);
  static const socialMedialBackground = Color(0xffFFF7EC);
  static const categoryBG4Color = Color(0xff8A52A9);
  static const itemBorderColor = Color(0xffE9E9E9);
  static const itemBgColor = Color(0xffFCFAFF);
  static const itemRateLightTextColor = Color(0xff5A5963);
  static const greenColor = Color(0xff0B8D00);
  static const cartBoxBorderColor = Color(0xffC7C7C7);
  static const categorySubBgColor = Color(0xffE3CAFB);
  static const iconArrowColor = Color(0xff464B62);
  static const Color pinkIndicator = Color(0xffEE3175);
  static const Color borderColor = Color(0xffD9E2AD);
  static const Color appBlue = Color(0xff172B4D);
  static const Color appPink = Color(0xffFFA5C5);
  static const Color appGrey = Color(0xff868686);
  static const Color wishListProduct = Color(0xFFF2F2F2);
  static const Color appWhite100 = Color(0xffF1F1F1);
  static const Color appWhite200 = Color(0xffF2F2F2);
  static const Color appPurple = Color(0xff5D0D8B);
  static const Color lightPurple = Color(0xffF4E7FF);
  static const Color appLightPurple = Color(0xffF0E7F8);
  static const Color appLightPurpleIcon = Color(0xff995EBB);
  static const Color appLightBlue = Color(0xff344663);
  static const Color appLightYellow = Color(0xffFFF9F4);
  static const Color appBorder = Color(0xffF0F0F0);
  static const Color appRateYellow = Color(0xffFFC107);
  static const Color appBeige = Color(0xffFFF7EC);
  static const Color appProductBorder = Color(0xffE9E9E9);
  static const Color appBarrierColor = Color(0xff4D4D4D);
  static const Color appSuggestionBorder = Color(0xffF5F5F5);
  static const Color appDividerColor = Color(0xffD9D9D9);
  static const Color appSkinColor = Color(0xffEBC8A0);
  static const Color lightPurpleColor = Color(0xffF5F3FD);
  static const Color lightPinkColor = Color(0xffFFECF3);
  static const Color greenLightColor = Color(0xffD5FFCB);
  static const Color pinkLightColor = Color(0xffFFCDDE);
  static const Color checkoutButtonColor = Color(0xff5B0F8B);
  static const Color purpleGreyColor = Color(0xffA0A4B8);
  static const Color appLightSkyBlue = Color(0xffD2D0EE);
  static const Color appSkyBlue = Color(0xffECE9FF);
  static const Color appDarkGreen = Color(0xff233F78);
  static const Color appHintTextColor = Color(0xffD1D3D4);
  static const Color appCreateACHintColor = Color(0xff9A9FA5);
  static const Color appBlueDarkColor = Color(0xff1A1B2D);
  static const Color appLightPurpleColor = Color(0xffFBF6FF);
  static const Color appBeigeColor = Color(0xffF9D3B7);
  static const Color appBabyPink = Color(0xffFF78A7);
  static const Color appLightPurplish = Color(0xffFAF4FF);
  static const Color appDarkGreyFont = Color(0xff4D526A);
  static const Color appPistaaColor = Color(0xffBCFFE3);
  static const Color appDarkRedColor = Color(0xffCC3C3C);
  static const Color appDarkGreenColor = Color(0xff069494);
  static const Color appDividerBoxColor = Color(0xffBFBFBF);
  static const Color appLightBeigeColor = Color(0xffFFF0E5);
  static const Color loyaltyPointBorderColor = Color(0xffE9F1F3);
  static const Color appLightYellowColor = Color(0xffFFFEDC);
  static const Color shadowColor = Color(0xff511587);
  static const Color mediumYellowColor = Color(0xffFFF9C7);
  static const Color mediumPinkColor = Color(0xffFF78A7);
  static const Color mediumRedColor = Color(0xffFF5656);
  static const Color lightYellowColor = Color(0xffF0EACB);
  static const Color mediumDarkYellowColor = Color(0xffD2BF5A);
  static const Color cardTextColor = Color(0xff7D7A79);
  static const Color cardDarkTextColor = Color(0xff0E0906);
  static const Color tabBackgroundLightPurple = Color(0xffFCF9FF);
  static const Color filterTabBGColor = Color(0xffF7F7F7);

  static Color hex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<BoxShadow> appBoxShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      spreadRadius: 0.2,
      color: appRed.withOpacity(0.2),
      blurRadius: 2,
    ),
  ];

  static List<BoxShadow> appDarkBoxShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      spreadRadius: 0.2,
      color: appWhite.withOpacity(0.2),
      blurRadius: 2,
    ),
  ];
}
