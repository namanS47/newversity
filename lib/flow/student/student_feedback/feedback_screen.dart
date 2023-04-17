import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

class StudentFeedBackScreen extends StatefulWidget {
  const StudentFeedBackScreen({Key? key}) : super(key: key);

  @override
  State<StudentFeedBackScreen> createState() => _StudentFeedBackScreenState();
}

class _StudentFeedBackScreenState extends State<StudentFeedBackScreen> {
  SessionDetailResponseModel? sessionDetailResponseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Row(
                        children: const [
                          AppImage(
                            image: ImageAsset.share,
                            color: AppColors.blackMerlin,
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(
                            width: 35,
                          ),
                          AppImage(
                            image: ImageAsset.close,
                            color: AppColors.blackMerlin,
                            height: 25,
                            width: 25,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  const Center(
                    child: AppImage(
                      image: ImageAsset.icGrowth,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  const Center(
                    child: AppText(
                      "Congratulation you have successfully completed a session with IITian Mentor",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getMentorDetails(),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  onMentorDetailsTap() {}

  Widget getMentorsProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 92,
        width: 70,
        child:
            sessionDetailResponseModel?.teacherDetail?.profilePictureUrl == null
                ? const AppImage(
                    image: ImageAsset.blueAvatar,
                  )
                : AppImage(
                    image: sessionDetailResponseModel
                            ?.teacherDetail?.profilePictureUrl ??
                        "",
                    fit: BoxFit.fill,
                  ),
      ),
    );
  }

  Widget getMentorDetails() {
    return GestureDetector(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        sessionDetailResponseModel?.teacherDetail?.name ??
                            "Kanhaiya",
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
                            children: [
                              const Icon(
                                Icons.star,
                                size: 8,
                                color: Colors.amber,
                              ),
                              AppText(
                                "${sessionDetailResponseModel?.studentRating}",
                                fontSize: 10,
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
                    sessionDetailResponseModel?.teacherDetail?.info ?? "",
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
}
