import 'package:flutter/material.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';

import '../flow/student/student_session/booking_session/model/student_session_argument.dart';
import '../navigation/app_routes.dart';
import '../resources/images.dart';
import '../utils/strings.dart';
import 'common_widgets.dart';

class MentorPersonalDetailCard extends StatelessWidget {
  final TeacherDetailsModel mentorDetail;
  final bool showTrimTags;

  const MentorPersonalDetailCard(
      {Key? key, required this.mentorDetail, this.showTrimTags = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sessionTags = StringsUtils.getTagListTextFromListOfTags(
        mentorDetail.tags ?? [],
        showTrimTagList: showTrimTags);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.bookSession,
            arguments: StudentSessionArgument(
                teacherId: mentorDetail.teacherId, pageIndex: 1));
      },
      child: SizedBox(
        height: 132,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getMentorsProfileImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      mentorDetail.name ?? "",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                      mentorDetail.education ?? "",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    AppText(
                      mentorDetail.title ?? "",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    Text(
                      sessionTags,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMentorsProfileImage() {
    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      width: 100,
      child: mentorDetail.profilePictureUrl == null ||
              mentorDetail.profilePictureUrl?.contains("https") == false
          ? const Center(
              child: AppImage(
                image: ImageAsset.blueAvatar,
              ),
            )
          : ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(18)),
              child: Image.network(
                mentorDetail.profilePictureUrl ?? "",
                fit: BoxFit.cover,
                height: 132,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Center(
                    child: AppImage(
                      image: ImageAsset.blueAvatar,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
