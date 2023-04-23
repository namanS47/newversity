import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

import '../../../../common/common_widgets.dart';
import '../../data/model/teacher_details/teacher_details.dart';
import '../bloc/profile_bloc/profile_bloc.dart';

class ProfileEditOption extends StatefulWidget {
  const ProfileEditOption({Key? key}) : super(key: key);

  @override
  State<ProfileEditOption> createState() => _ProfileEditOptionState();
}

class _ProfileEditOptionState extends State<ProfileEditOption> {
  TeacherDetailsModel? teacherDetails;

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetailsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileStates>(
        listener: (context, state) {
          if (state is FetchedTeachersProfileState) {
            teacherDetails = state.teacherDetails;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: 192,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: AppColors.ligCyan),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () => {Navigator.pop(context)},
                          child: const AppImage(
                            image: ImageAsset.arrowBack,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        teacherDetails != null
                            ? AppText(
                                "Hi ${teacherDetails?.name ?? ""}",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        const AppText(
                          "You can edit your personal details here by step wise",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    getPersonalInfoEditLayout(),
                    const SizedBox(
                      height: 20,
                    ),
                    getExperienceAndQualificationLayout(),
                    const SizedBox(
                      height: 20,
                    ),
                    getTeacherPreferenceLayout()
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  onPersonalInfoTap() {
    Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard,
        arguments:
            ProfileDashboardArguments(directedIndex: 1, showBackButton: true));
  }

  onExperienceAndEducationTap() {
    Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard,
        arguments:
            ProfileDashboardArguments(directedIndex: 2, showBackButton: true));
  }

  onTeacherPreferenceTap() {
    Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard,
        arguments:
            ProfileDashboardArguments(directedIndex: 4, showBackButton: true));
  }

  Widget getPersonalInfoEditLayout() {
    return GestureDetector(
      onTap: () => onPersonalInfoTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppText("Personal Information"),
              AppImage(
                image: ImageAsset.editPrimary,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getExperienceAndQualificationLayout() {
    return GestureDetector(
      onTap: () => onExperienceAndEducationTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppText("Experience & Qualification"),
              AppImage(
                image: ImageAsset.editPrimary,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTeacherPreferenceLayout() {
    return GestureDetector(
      onTap: () => onTeacherPreferenceTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppText("TeachingPreference"),
              AppImage(
                image: ImageAsset.editPrimary,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
