import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:newversity/flow/teacher/profile/experience_and_education.dart';
import 'package:newversity/flow/teacher/profile/personal_info.dart';
import 'package:newversity/flow/teacher/profile/exam_cracked.dart';
import 'package:newversity/flow/teacher/profile/selection_details.dart';
import 'package:newversity/flow/teacher/profile/teaching_prefrences.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'bloc/profile_bloc/profile_bloc.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key}) : super(key: key);

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<ProfileBloc, ProfileStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().profileCardList = [
              BlocProvider<TeacherDetailsBloc>(
                  create: (context) => TeacherDetailsBloc(),
                  child: const PersonalInformation()),
              const ExperienceAndEducation(),
              const ExamsCracked(),
              const SelectionDetails(),
            ];
          }
          return SafeArea(
            bottom: false,
            child: ListView(
              primary: true,
              shrinkWrap: true,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        visible: !(context.read<ProfileBloc>().currentProfileStep == 1),
                        child: GestureDetector(
                          onTap: () async {
                            context.read<ProfileBloc>().add(ChangeProfileCardIndexEvent(isBack: true));
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
                                roundedEdges: Radius.circular(100),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed(AppRoutes.teacherHomePageRoute);
                          },
                          child: Text("Skip"),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (context.read<ProfileBloc>().profileCardList.isNotEmpty) ...[
                  context.read<ProfileBloc>().profileCardList.elementAt(
                      context.read<ProfileBloc>().currentProfileStep-1),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
