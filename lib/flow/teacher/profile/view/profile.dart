import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/index/bloc/index_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/flow/teacher/profile/view/overview.dart';
import 'package:newversity/flow/teacher/profile/view/review.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../bloc/profile_bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TeacherDetails? teacherDetails;
  ProfileCompletionPercentageResponse? profileCompletionPercentageResponse;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetailsEvent());
    BlocProvider.of<ProfileBloc>(context).add(FetchProfileCompletionInfoEvent());
  }

  onDrawerTap() {
    if (context.read<IndexBloc>().scaffoldKey.currentState != null) {
      context.read<IndexBloc>().scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      listener: (context, state) {
        if (state is FetchedTeachersProfileState) {
          teacherDetails = state.teacherDetails;
          // TODO: implement listener
        }
        if (state is FetchedProfileCompletionInfoState) {
          profileCompletionPercentageResponse = state.percentageResponse;
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 133,
                    decoration:
                        const BoxDecoration(color: AppColors.perSessionRate),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 30.0, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () => {Navigator.pop(context)},
                                  child: const AppImage(
                                      image: ImageAsset.arrowBack)),
                              const SizedBox(
                                width: 10,
                              ),
                              const AppText(
                                "Profile",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () => onDrawerTap(),
                              child: const AppImage(image: ImageAsset.drawer)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                bottom: 10,
                top: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 110,
                      ),
                      Row(
                        children: [
                          getProfileImage(),
                          const SizedBox(
                            width: 17,
                          ),
                          getDetailsWithEditLayout(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                    "Mob : ${teacherDetails?.mobileNumber ?? ""}"),
                                const SizedBox(
                                  height: 10,
                                ),
                                AppText(
                                    "Email : ${teacherDetails?.email ?? ""}"),
                              ],
                            ),
                          ),
                          profileCompletionPercentageResponse != null
                              ? getCompletenessLayout()
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getProfileTab(),
                      context.read<ProfileBloc>().selctedProfileTab == 0
                          ? BlocProvider<ProfileBloc>(
                              create: (context) => ProfileBloc(),
                              child: const ProfileOverview())
                          : BlocProvider<ProfileBloc>(
                              create: (context) => ProfileBloc(),
                              child: const ProfileReview()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int percentageComplete = 20;

  Widget getProfileTab() {
    return Container(
      height: 44,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.grey32,
        borderRadius: BorderRadius.circular(38.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey32.withOpacity(0.15),
            blurRadius: 4.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
        child: Row(
          children: context
              .read<ProfileBloc>()
              .listOfProfileSection
              .map((item) => profileTab(item))
              .toList(),
        ),
      ),
    );
  }

  Widget profileTab(String item) {
    int index = context.read<ProfileBloc>().listOfProfileSection.indexOf(item);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: InkWell(
          onTap: () {
            onTabTap(index);
          },
          child: context.read<ProfileBloc>().selctedProfileTab == index
              ? Container(
                  height: 38,
                  decoration: BoxDecoration(
                      color: AppColors.cyanBlue,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Center(
                    child: AppText(
                      item,
                      fontSize: 14,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : SizedBox(
                  height: 38,
                  child: Center(
                    child: Text(
                      item,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  onTabTap(int index) {
    context.read<ProfileBloc>().add(ChangeProfileTab(index: index));
  }

  Widget getCompletenessLayout() {
    return Row(
      children: [
        const AppText(
          "Completeness",
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          width: 20,
        ),
        CircularPercentIndicator(
          radius: 30.0,
          animationDuration: 1200,
          animation: true,
          lineWidth: 6.0,
          percent:
              (profileCompletionPercentageResponse!.completePercentage ?? 0) /
                  100,
          center: Padding(
            padding: const EdgeInsets.all(3.0),
            child: AppText(
              "${profileCompletionPercentageResponse!.completePercentage ?? 0} %",
              fontSize: 12,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              color: AppColors.primaryColor,
            ),
          ),
          progressColor: AppColors.primaryColor,
        )
      ],
    );
  }

  onEditTap() {
    Navigator.of(context).pushNamed(AppRoutes.profileEdit);
  }

  Widget getEditLayout() {
    return GestureDetector(
      onTap: () => onEditTap(),
      child: Row(
        children: const [
          AppText(
            "Edit",
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          SizedBox(
            width: 5,
          ),
          AppImage(image: ImageAsset.edit),
        ],
      ),
    );
  }

  Widget getDetailsWithEditLayout() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  teacherDetails?.name ?? "",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                getEditLayout()
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            AppText(
              "Mob: ${teacherDetails?.mobileNumber ?? ""}",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.blackMerlin,
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileImage() {
    return Stack(
      children: [
        Container(
          height: 73,
          width: 73,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: SizedBox(
              height: 66,
              width: 66,
              child: CircleAvatar(
                child: AppImage(
                  image: teacherDetails?.profilePictureUrl ??
                      ImageAsset.blueAvatar,
                ),
              ),
            ),
          ),
        ),
        const Positioned(
            right: -2,
            bottom: 5,
            child: AppImage(
              image: ImageAsset.check,
            ))
      ],
    );
  }
}
