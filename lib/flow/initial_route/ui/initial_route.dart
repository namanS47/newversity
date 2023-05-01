import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';

import '../app_bloc/app_bloc.dart';

class InitialRoute extends StatelessWidget {
  const InitialRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, AppState state) {
        if (state is RedirectToLoginRoute) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.loginRoute);
        } else if (state is RedirectToTeacherHomeRoute) {
          Navigator.pushReplacementNamed(
              context, AppRoutes.teacherHomePageRoute,
              arguments: false);
        } else if (state is RedirectToTeacherPersonalInformationRoute) {
          Navigator.pushReplacementNamed(
              context, AppRoutes.teacherProfileDashBoard,
              arguments: ProfileDashboardArguments(
                  directedIndex: 1, showBackButton: false));
        } else if (state is RedirectToStudentHome) {
          Navigator.pushReplacementNamed(context, AppRoutes.studentHome,
              arguments: true);
        } else if (state is RedirectToStudentProfileDashboardRoute) {
          Navigator.pushReplacementNamed(
              context, AppRoutes.studentProfileDashboardRoute);
        } else if (state is SomethingWentWrongState) {
          Navigator.pushReplacementNamed(
              context, AppRoutes.somethingWentWrongRoute);
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
