import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/notification/model/notification_model.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../../../../themes/colors.dart';

class StudentNotificationScreen extends StatefulWidget {
  const StudentNotificationScreen({Key? key}) : super(key: key);

  @override
  State<StudentNotificationScreen> createState() =>
      _StudentNotificationScreenState();
}

class _StudentNotificationScreenState extends State<StudentNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () => {Navigator.pop(context)},
                            child: const AppImage(image: ImageAsset.arrowBack)),
                        const SizedBox(
                          width: 7,
                        ),
                        const AppText(
                          "Notifications",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    getNotificationListLayout(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<StudentNotificationModel> listOfNotification =
      StudentNotificationModel.listOfStudentNotificationModel;

  Widget getNotificationListLayout() {
    return Wrap(
      runSpacing: 14,
      spacing: 14,
      children: List.generate(
          listOfNotification.length, (index) => getNotificationView(index)),
    );
  }

  Widget getSenderProfilePic(int index) {
    return SizedBox(
      height: 40,
      width: 40,
      child: CircleAvatar(
        radius: 30.0,
        foregroundImage: listOfNotification[index].senderProfilePicture != null
            ? NetworkImage(listOfNotification[index].senderProfilePicture!)
            : null,
        child: listOfNotification[index].senderProfilePicture == null
            ? const AppImage(
                image: ImageAsset.blueAvatar,
              )
            : CommonWidgets.getCircularProgressIndicator(),
      ),
    );
  }

  Widget getNotificationView(int index) {
    return Visibility(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getSenderProfilePic(index),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          listOfNotification[index].msg ?? "",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        AppText(
                          DateTimeUtils.getTimeInAMOrPM(
                              listOfNotification[index].msgDatetime ??
                                  DateTime.now()),
                          color: AppColors.grey55,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        getNotificationActionCTA(index),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getNotificationActionCTA(index) {
    return Container(
      width: 107,
      height: 27,
      decoration: BoxDecoration(
        color: AppColors.cyanBlue,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: AppText(
          listOfNotification[index].action ?? "",
          fontSize: 12,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
