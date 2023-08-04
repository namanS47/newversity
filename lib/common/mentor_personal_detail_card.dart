import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/utils/enums.dart';

import '../flow/student/student_session/booking_session/model/student_session_argument.dart';
import '../navigation/app_routes.dart';
import '../resources/images.dart';
import '../themes/colors.dart';
import '../utils/strings.dart';
import 'common_widgets.dart';

class MentorPersonalDetailCard extends StatelessWidget {
  final TeacherDetailsModel mentorDetail;
  final bool showTrimTags;
  final bool showScopeTags;
  final void Function()? onCardTap;

  const MentorPersonalDetailCard(
      {Key? key, required this.mentorDetail, this.showTrimTags = true, this.showScopeTags = false, this.onCardTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> expertiseTags = mentorDetail.tags
            ?.where((tagModel) =>
                tagModel.tagCategory ==
                TagCategory.expertise.toString().split(".")[1])
            .map((tagModel) => tagModel.tagName!)
            .toList() ??
        [];
    List<String> scopeTags = mentorDetail.tags
            ?.where((tagModel) =>
                tagModel.tagCategory ==
                TagCategory.scope.toString().split(".")[1])
            .map((tagModel) => tagModel.tagName!)
            .toList() ??
        [];
    String sessionTags = StringsUtils.getTagListTextFromListOfTags(
        expertiseTags,
        showTrimTagList: showTrimTags);
    return GestureDetector(
      onTap: onCardTap ?? () {
        Navigator.of(context).pushNamed(AppRoutes.bookSession,
            arguments: StudentSessionArgument(
                teacherId: mentorDetail.teacherId, pageIndex: 0));
      },
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getMentorsProfileImage(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          mentorDetail.name ?? "",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.cyanBlue,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              ImageAsset.educationFilled,
                              width: 12,
                              height: 12,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: AppText(
                                mentorDetail.title ?? "",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              ImageAsset.messages,
                              width: 12,
                              height: 12,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                              child: AppText(
                                sessionTags,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.dimGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            if(showScopeTags) SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.lightBlue,
                height: 30,
                child: Row(
                  children: scopeTags
                      .map((tags) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                tags,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMentorsProfileImage() {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      width: 100,
      child: mentorDetail.profilePictureUrl == null ||
              mentorDetail.profilePictureUrl?.contains("https") == false
          ? const AppImage(
              image: ImageAsset.blueAvatar,
            )
          : CircleAvatar(
              radius: 33,
              backgroundImage:
                  NetworkImage(mentorDetail.profilePictureUrl ?? ""),
            ),
    );
  }
}
