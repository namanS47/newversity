import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../storage/app_constants.dart';
import '../app_bloc/app_bloc.dart';

class InitialRoute extends StatefulWidget {
  const InitialRoute({Key? key}) : super(key: key);

  @override
  State<InitialRoute> createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {
  @override
  void initState() {
    if (GlobalConstants.isCheckedForAppUpdate) {
      BlocProvider.of<AppBloc>(context).add(FetchInitialRouteEvent());
    } else {
      BlocProvider.of<AppBloc>(context).add(CheckForAppUpdateEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, AppState state) {
        if(state is CheckingAppUpdateFlowComplete) {
          BlocProvider.of<AppBloc>(context).add(FetchInitialRouteEvent());
        }
        if (state is ShowAppUpdateDialogue) {
          _showUpdateDialog(state);
        } else if (state is RedirectToLoginRoute) {
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
          bool index = state.index == 1;
          Navigator.pushReplacementNamed(
              context, AppRoutes.studentProfileDashboardRoute, arguments: index);
        } else if (state is SomethingWentWrongState) {
          Navigator.pushReplacementNamed(
              context, AppRoutes.somethingWentWrongRoute);
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<void> _showUpdateDialog(ShowAppUpdateDialogue state) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext cnt) {
        return WillPopScope(
          onWillPop: () {
            if (state.mandatory) {
              SystemNavigator.pop();
              return Future.value(false);
            } else {
              context.read<AppBloc>().add(FetchInitialRouteEvent());
              return Future.value(true);
            }
          },
          child: AlertDialog(
            title: Text(
              state.mandatory ? 'Update App?' : "Please update app to continue",
              style: const TextStyle(
                  color: AppColors.blackRussian, fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  if (!state.mandatory)
                    const Text(
                      'A new version of Newversity is available!.',
                      style: TextStyle(
                          color: AppColors.blackRussian,
                          fontWeight: FontWeight.w500),
                    ),
                  if (!state.mandatory)
                    const Text(
                      'Would you like to update it now?',
                      style: TextStyle(
                          color: AppColors.blackRussian,
                          fontWeight: FontWeight.w500),
                    ),
                  if (state.mandatory)
                    const Text(
                      "To continue using the app please update it to the latest version",
                      style: TextStyle(
                          color: AppColors.blackRussian,
                          fontWeight: FontWeight.w500),
                    )
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              if (!state.mandatory)
                TextButton(
                  child: const SizedBox(
                      child: Text(
                    'Later',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.blackRussian,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<AppBloc>().add(FetchInitialRouteEvent());
                  },
                ),
              TextButton(
                child: const SizedBox(
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.blackRussian,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () async {
                  launchPlayStore(state);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> launchPlayStore(ShowAppUpdateDialogue state) async {
    Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.newversity.android");
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
