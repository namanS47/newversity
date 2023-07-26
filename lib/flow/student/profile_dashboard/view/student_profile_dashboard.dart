import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newversity/flow/student/profile_dashboard/bloc/profile_dahsbord_bloc.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/view/preparing_for_exam.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../../common/common_utils.dart';
import '../../../../navigation/app_routes.dart';
import 'chose_location.dart';

class StudentProfileDashboard extends StatefulWidget {
  const StudentProfileDashboard({Key? key}) : super(key: key);

  @override
  State<StudentProfileDashboard> createState() =>
      _StudentProfileDashboardState();
}

class _StudentProfileDashboardState extends State<StudentProfileDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<ProfileDashboardBloc, ProfileDashboardStates>(
        listener: (context, state) {
          if (state is StudentDetailsSavedOnSkipState) {
            Navigator.of(context)
                .pushNamed(AppRoutes.studentHome, arguments: true);
          }
        },
        builder: (context, state) {
          if (state is ProfileDashboardInitialState) {
            context.read<ProfileDashboardBloc>().profileCardList = [
              const StudentProfileLocation(),
              const ExamsPreparingFor(),
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
                        visible: !(context
                                .read<ProfileDashboardBloc>()
                                .currentProfileStep ==
                            1),
                        child: GestureDetector(
                          onTap: () async {
                            if (context
                                    .read<ProfileDashboardBloc>()
                                    .currentProfileStep >
                                1) {
                              context.read<ProfileDashboardBloc>().add(
                                  ChangeStudentProfileCardIndexEvent(isBack: true));
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
                              .read<ProfileDashboardBloc>()
                              .profileCardList
                              .isNotEmpty) ...[
                            SizedBox(
                              width: context
                                  .read<ProfileDashboardBloc>()
                                  .sliderWidth,
                              child: StepProgressIndicator(
                                totalSteps: context
                                    .read<ProfileDashboardBloc>()
                                    .profileCardList
                                    .length,
                                currentStep: context
                                    .read<ProfileDashboardBloc>()
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => onSkipTap(),
                          child: const Text("Skip"),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (context
                    .read<ProfileDashboardBloc>()
                    .profileCardList
                    .isNotEmpty) ...[
                  context
                      .read<ProfileDashboardBloc>()
                      .profileCardList
                      .elementAt(context
                              .read<ProfileDashboardBloc>()
                              .currentProfileStep -
                          1),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  onSkipTap() {
    BlocProvider.of<ProfileDashboardBloc>(context).add(
      StudentDetailSavingOnSkipEvent(
        studentDetailSavingRequestModel: StudentDetailSavingRequestModel(
          studentId: CommonUtils().getLoggedInUser(),
        ),
      ),
    );
  }
}
