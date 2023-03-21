import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/navigation/app_routes.dart';

import '../app_bloc/app_bloc.dart';

class InitialRoute extends StatelessWidget {
  const InitialRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, AppState state) {
        if(state is RedirectToLoginRoute) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.loginRoute);
        } else if(state is RedirectToTeacherHomeRoute){
          Navigator.pushReplacementNamed(context, AppRoutes.teacherHomePageRoute);
        } else if(state is RedirectToTeacherPersonalInformationRoute) {
          Navigator.pushReplacementNamed(context, AppRoutes.teacherPersonalInformationRoute);
        } else if(state is RedirectToStudentHome) {
          Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
        } else if(state is SomethingWentWrongState) {
          Navigator.pushReplacementNamed(context, AppRoutes.somethingWentWrongRoute);
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
