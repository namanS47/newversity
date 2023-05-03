import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:newversity/flow/teacher/profile/exam_cracked.dart';
import 'package:newversity/flow/teacher/profile/experience_and_education.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/flow/teacher/profile/teacher_personal_info.dart';
import 'package:newversity/flow/teacher/profile/selection_details.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../common/common_utils.dart';
import '../data/model/teacher_details/teacher_details_model.dart';
import 'bloc/profile_bloc/profile_bloc.dart';

class ProfileDashboard extends StatefulWidget {
  final ProfileDashboardArguments profileDashboardArguments;

  const ProfileDashboard({Key? key, required this.profileDashboardArguments})
      : super(key: key);

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().currentProfileStep =
        widget.profileDashboardArguments.directedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<ProfileBloc, ProfileStates>(
        listener: (context, state) {
          if (state is ProfileDetailsSavingSuccessState) {
            if (context.read<ProfileBloc>().currentProfileStep ==
                context.read<ProfileBloc>().profileCardList.length) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.teacherHomePageRoute, (route) => false,
                  arguments: false);
            } else {
              context.read<ProfileBloc>().add(ChangeProfileCardIndexEvent());
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().profileCardList = [
              BlocProvider<TeacherDetailsBloc>(
                  create: (context) => TeacherDetailsBloc(),
                  child: TeacherPersonalInformation(
                    profileDashboardArguments: widget.profileDashboardArguments,
                  )),
              ExperienceAndEducation(
                profileDashboardArguments: widget.profileDashboardArguments,
              ),
              const ExamsCracked(),
              SelectionDetails(
                profileDashboardArguments: widget.profileDashboardArguments,
              ),
            ];
          }
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        visible: widget
                                .profileDashboardArguments.showBackButton ||
                            !(context.read<ProfileBloc>().currentProfileStep ==
                                1),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (context.read<ProfileBloc>().currentProfileStep >
                                1) {
                              context.read<ProfileBloc>().add(
                                  ChangeProfileCardIndexEvent(isBack: true));
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 33),
                            child: SvgPicture.asset(ImageAsset.arrowBack),
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          if (context
                              .read<ProfileBloc>()
                              .profileCardList
                              .isNotEmpty) ...[
                            SizedBox(
                              width: context.read<ProfileBloc>().sliderWidth,
                              child: StepProgressIndicator(
                                totalSteps: context
                                    .read<ProfileBloc>()
                                    .profileCardList
                                    .length,
                                currentStep: context
                                    .read<ProfileBloc>()
                                    .currentProfileStep,
                                padding: 0,
                                selectedColor: AppColors.primaryColor,
                                unselectedColor: AppColors.grey32,
                                roundedEdges: const Radius.circular(100),
                              ),
                            ),
                          ],
                        ],
                      ),
                      GestureDetector(
                        onTap: () => onSkipTap(),
                        child: const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Center(
                              child: AppText(
                            "Skip",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                if (context.read<ProfileBloc>().profileCardList.isNotEmpty) ...[
                  context.read<ProfileBloc>().profileCardList.elementAt(
                      context.read<ProfileBloc>().currentProfileStep - 1),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  onSkipTap() {
    BlocProvider.of<ProfileBloc>(context).add(
      SaveProfileDetailsEvent(
        teacherDetails: TeacherDetailsModel(
          teacherId: CommonUtils().getLoggedInUser(),
        ),
      ),
    );
  }
}
