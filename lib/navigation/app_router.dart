import 'package:flutter/material.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/ui/home/ui/home_screen.dart';
import 'package:newversity/ui/login/login_arguments.dart';
import 'package:newversity/ui/login/login_screen.dart';
import 'package:newversity/ui/login/otp_route.dart';

class AppRouter {
  Route route(RouteSettings routeSettings) {
    return CustomRoute(
        builder: (context) {
          return _getNavigationWidget(context, routeSettings.name,
              params: routeSettings.arguments);
        },
        settings: routeSettings);
  }

  Widget _getNavigationWidget(BuildContext context, route, {dynamic params}) {
    return _navigation(route, params: params);
  }

  _navigation(route, {dynamic params}) {
    if(route.toString() == AppRoutes.loginRoute) {
      return const LoginPage();
    }
    if(route.toString() == AppRoutes.otpRoute) {
      return OtpVerificationScreen(loginArguments: params as LoginArguments,);
    }
    if(route.toString() == AppRoutes.homeScreen) {
      return const HomeScreen();
    }
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}