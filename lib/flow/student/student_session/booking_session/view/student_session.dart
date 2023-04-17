import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/student_session_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/review.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../resources/images.dart';
import '../bloc/student_session_bloc.dart';
import 'about.dart';
import 'availability.dart';

class StudentSessionScreen extends StatefulWidget {
  final StudentSessionArgument studentSessionArgument;

  const StudentSessionScreen({Key? key, required this.studentSessionArgument})
      : super(key: key);

  @override
  State<StudentSessionScreen> createState() => _StudentSessionScreenState();
}

class _StudentSessionScreenState extends State<StudentSessionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StudentSessionBloc>(context).add(FetchTeacherDetailsEvent(
        teacherId: widget.studentSessionArgument.teacherId ?? ""));
  }

  TeacherDetails? teacherDetails;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionBloc, StudentSessionStates>(
      listener: (context, state) {
        if (state is FetchedTeacherDetailsState) {
          teacherDetails = state.teacherDetails;
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: getScreeContent(),
        );
      },
    );
  }

  Widget getTopBanner() {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
          color: AppColors.lightCyan,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => {Navigator.pop(context)},
                        child: const AppImage(image: ImageAsset.arrowBack)),
                    const AppImage(
                      image: ImageAsset.share,
                      height: 19,
                      width: 16,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: getMentorDetails(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getMentorsProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 92,
        width: 70,
        child: teacherDetails?.profilePictureUrl == null
            ? const AppImage(
                image: ImageAsset.blueAvatar,
              )
            : AppImage(
                image: teacherDetails?.profilePictureUrl ?? "",
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget getMentorDetails() {
    return Visibility(
      visible: teacherDetails != null,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1, color: AppColors.grey32)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getMentorsProfileImage(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        teacherDetails?.name ?? "",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.grey32,
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                        width: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.star,
                                size: 8,
                                color: Colors.amber,
                              ),
                              Text(
                                "5",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(
                    teacherDetails?.info ?? "",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget getConfirmCta() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: AppCta(
        onTap: onButtonTap,
        isLoading: false,
      ),
    );
  }

  onButtonTap() {}

  onTabTap(int index) {
    context.read<StudentSessionBloc>().add(UpdateTabBarEvent(index: index));
  }

  Widget categoryTab(String item) {
    int index =
        context.read<StudentSessionBloc>().sessionCategory.indexOf(item);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: InkWell(
          onTap: () => onTabTap(index),
          child:
              context.read<StudentSessionBloc>().selectedSessionIndex == index
                  ? Container(
                      height: 38,
                      decoration: BoxDecoration(
                          color: AppColors.cyanBlue,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Center(
                        child: Text(
                          item,
                          style: const TextStyle(color: AppColors.whiteColor),
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

  Widget getScreeContent() {
    return Stack(
      children: [
        ListView(
          children: [
            Column(
              children: [
                getTopBanner(),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCategoryTab(),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (context
                              .read<StudentSessionBloc>()
                              .selectedSessionIndex ==
                          0)
                        AboutSession(
                          studentSessionArgument: widget.studentSessionArgument,
                        ),
                      if (context
                              .read<StudentSessionBloc>()
                              .selectedSessionIndex ==
                          1)
                        const SessionAvailability(),
                      if (context
                              .read<StudentSessionBloc>()
                              .selectedSessionIndex ==
                          2)
                        const SessionReview()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Expanded(child: Container()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: AppCta(
                text: AppStrings.bookSession,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget getCategoryTab() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.grey32,
        borderRadius: BorderRadius.circular(20.0),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: context
            .read<StudentSessionBloc>()
            .sessionCategory
            .map((item) => categoryTab(item))
            .toList(),
      ),
      // child: ListView.separated(
      //   padding: EdgeInsets.only(left: 5, right: 16, top: 5,bottom: 5),
      //   physics: const ClampingScrollPhysics(),
      //   shrinkWrap: true,
      //   scrollDirection: Axis.horizontal,
      //   itemCount: sessionCategory.length,
      //   itemBuilder: (context, index) => categoryTab(index, context),
      //   separatorBuilder: (BuildContext context, int index) => SizedBox(width: 24),
      // ),
    );
  }
}
