import 'package:get/get.dart';
import 'package:newversity/routes/route_contants.dart';
import 'package:newversity/ui/home/ui/home_screen.dart';
import 'package:newversity/ui/login/login_screen.dart';
import 'package:newversity/ui/login/otp_route.dart';
import 'package:newversity/ui/signup/signup.dart';

class RouteHelper {

  static String getSplashRoute() => RouteConstant.splash;
  static String getLoginPage() => RouteConstant.login;
  static String getSignUpPage() => RouteConstant.signUp;
  static String getOtpPage() => RouteConstant.otp;
  static String getHomePage() => RouteConstant.home;

  static List<GetPage> pages = [
    GetPage(name: RouteConstant.login, page: () => const LoginPage()),
    GetPage(name: RouteConstant.signUp, page: () =>   SignupPage(user: Get.arguments,)),
    GetPage(name: RouteConstant.otp, page: () =>  OtpVerificationScreen(loginArguments: Get.arguments)),
    GetPage(name: RouteConstant.home, page: () => const HomeScreen()),
  ];
}