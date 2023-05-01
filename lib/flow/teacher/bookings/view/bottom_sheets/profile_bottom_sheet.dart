import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/teacher/bookings/bloc/session_details_bloc/booking_session_details_bloc.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

class ProfileBottomSheet extends StatefulWidget {
  final String studentId;
  const ProfileBottomSheet({Key? key, required this.studentId})
      : super(key: key);

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  List<String> communicationLanguageList = ["English", "Hindi", "Sanskrit"];
  List<String> listOfTargetExam = ["Neet"];
  List<String> listOfAcademicInformation = ["+2 Passed"];

  StudentDetail? studentDetail;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingSessionDetailsBloc>(context)
        .add(FetchStudentDetailsEvent(studentId: widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingSessionDetailsBloc, BookingSessionDetailsStates>(
      listener: (context, state) {
        if (state is FetchedStudentDetailsState) {
          studentDetail = state.studentDetail;
        }
      },
      builder: (context, state) {
        return studentDetail != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Container(
                      height: 2,
                      width: 60,
                      decoration: BoxDecoration(color: AppColors.grey50),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        children: [
                          getProfileImage(),
                          const SizedBox(
                            height: 10,
                          ),
                          AppText(
                            studentDetail?.name ?? "",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          getLocationView(),
                          const SizedBox(
                            height: 20,
                          ),
                          AppText(
                            studentDetail?.info ?? "",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getAcademicInformation(),
                    const SizedBox(
                      height: 20,
                    ),
                    getTargetExamView(),
                    const SizedBox(
                      height: 20,
                    ),
                    getCommunicationLanguage(),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
      },
    );
  }

  Widget getProfileImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        height: 66,
        width: 66,
        child: CircleAvatar(
          radius: 30.0,
          foregroundImage: studentDetail?.profilePictureUrl != null
              ? NetworkImage(studentDetail?.profilePictureUrl ?? "")
              : null,
          child: studentDetail?.profilePictureUrl == null
              ? const AppImage(
                  image: ImageAsset.blueAvatar,
                )
              : CommonWidgets.getCircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getCommunicationLanguage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Communication Language",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 15,
          runSpacing: 12,
          children: List.generate(
            studentDetail?.language?.length ?? 0,
            (curIndex) {
              return comView(curIndex);
            },
          ),
        )
      ],
    );
  }

  Widget getTargetExamView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Target Exam",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 15,
          runSpacing: 12,
          children: List.generate(
            studentDetail?.tags?.length ?? 0,
            (curIndex) {
              return targetView(curIndex);
            },
          ),
        )
      ],
    );
  }

  Widget comView(int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: AppText(
                studentDetail?.language?[index] ?? "",
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget targetView(int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: AppText(
                studentDetail?.tags?[index] ?? "",
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAcademicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Academic Information",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 15,
          runSpacing: 12,
          children: List.generate(
            listOfAcademicInformation.length,
            (curIndex) {
              return academicView(curIndex);
            },
          ),
        )
      ],
    );
  }

  Widget academicView(int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: AppText(
                listOfAcademicInformation[index],
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getLocationView() {
    return Container(
      width: 83,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppImage(image: ImageAsset.location),
              const SizedBox(
                width: 5,
              ),
              AppText(
                studentDetail?.location ?? "",
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
