import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/seesion/book_session.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:newversity/flow/teacher/presentation/onboarding_route/teacher_personal_information_route.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/room/room.dart';

import '../flow/login/login_arguments.dart';
import '../flow/login/login_screen.dart';
import '../flow/login/otp_route.dart';
import '../flow/student/home/ui/home_screen.dart';

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
    if (route.toString() == AppRoutes.loginRoute) {
      return const LoginScreen();
    }
    if (route.toString() == AppRoutes.otpRoute) {
      return OtpRoute(
        loginArguments: params as LoginArguments,
      );
    }
    if (route.toString() == AppRoutes.homeScreen) {
      return const HomeScreen();
    }
    if (route.toString() == AppRoutes.bookSession) {
      return const BookSession();
    }
    if (route.toString() == AppRoutes.teacherPersonalInformationRoute) {
      return BlocProvider<TeacherDetailsBloc>(
        create: (context) => TeacherDetailsBloc(),
        child: TeacherPersonalInfoRoute(),
      );
    }
    if (route.toString() == AppRoutes.roomPageRoute) {
      return const RoomPage();
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
