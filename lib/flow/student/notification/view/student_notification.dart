import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/notification/bloc/notification_bloc.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../../../../themes/colors.dart';
import '../data/model/notification_details_response_model.dart';

class StudentNotificationScreen extends StatefulWidget {
  const StudentNotificationScreen({Key? key}) : super(key: key);

  @override
  State<StudentNotificationScreen> createState() =>
      _StudentNotificationScreenState();
}

class _StudentNotificationScreenState extends State<StudentNotificationScreen> {
  @override
  void initState() {
    BlocProvider.of<NotificationBloc>(context)
        .add(FetchAllUserNotificationsEvent());
    super.initState();
  }

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
                    BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        if (state is FetchAllUserNotificationLoadingState) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Center(
                              child: CommonWidgets.getCircularProgressIndicator(color: AppColors.cyanBlue),
                            ),
                          );
                        } else if (state
                            is FetchAllUserNotificationSuccessState) {
                          if(state.notificationList.isNotEmpty) {
                            return getNotificationListLayout(state.notificationList);
                          } else {
                            return noNotificationWidget();
                          }
                        } else {
                          return noNotificationWidget();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget noNotificationWidget() {
    return Text("No Notification");
  }

  Widget getNotificationListLayout(
      List<NotificationDetailsResponseModel> listOfNotification) {
    return Wrap(
      runSpacing: 14,
      spacing: 14,
      children: List.generate(
          listOfNotification.length, (index) => getNotificationView(listOfNotification[index])),
    );
  }

  Widget getSenderProfilePic() {
    return const SizedBox(
      height: 40,
      width: 40,
      child: AppImage(image: ImageAsset.appIcon,),
    );
  }

  Widget getNotificationView(NotificationDetailsResponseModel notification) {
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
                  getSenderProfilePic(),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          notification.body ?? "",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        AppText(
                          DateTimeUtils.getTimeInAMOrPM(
                             notification.date ??
                                  DateTime.now()),
                          color: AppColors.grey55,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // getNotificationActionCTA(),
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
}
