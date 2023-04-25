import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/common/mentor_detail_card.dart';
import 'package:newversity/flow/student/home/bloc/student_home_bloc.dart';
import 'package:newversity/flow/student/home/model/session_details.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/student_session_argument.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:newversity/utils/date_time_utils.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../resources/images.dart';
import '../../../../utils/enums.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  StudentDetail? studentDetail;
  List<TagModel> lisOfTagRequestModel = [];
  List<TeacherDetailsModel> lisOfTeachersDetails = [];

  List<String> listOfStudentTag = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentHomeBloc>(context).add(FetchStudentDetailEvent());
    BlocProvider.of<StudentHomeBloc>(context).add(FetchUpcomingSessionEvent(
        sessionType: getSessionType(SessionType.upcoming)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.lightCyan,
          ),
          BlocConsumer<StudentHomeBloc, StudentHomeStates>(
            listener: (context, state) {
              if (state is FetchedStudentDetailsState) {
                studentDetail = state.studentDetail;
                listOfStudentTag = studentDetail!.tags!;
                for (String element in listOfStudentTag) {
                  lisOfTagRequestModel.add(TagModel(tagName: element));
                }
                BlocProvider.of<StudentHomeBloc>(context).add(
                    FetchMentorsByTagEvent(
                        tagRequestModel: TagRequestModel(
                            tagModelList: lisOfTagRequestModel)));
              }
              if (state is FetchedMentorsWithTagState) {
                lisOfTeachersDetails = state.lisOfTeacherDetails;
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          studentDetail != null
                              ? getProfileWidget()
                              : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                          getFindMentorHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getFindMentorSearchWidget(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                context
                                        .read<StudentHomeBloc>()
                                        .listOfUpcomingSessions
                                        .isNotEmpty
                                    ? getNextSessionCarousel()
                                    : Container(),
                                const SizedBox(
                                  height: 20,
                                ),
                                lisOfTeachersDetails.isNotEmpty
                                    ? getNearByHeader()
                                    : Container(),
                                const SizedBox(
                                  height: 20,
                                ),
                                lisOfTeachersDetails.isNotEmpty
                                    ? getNearbyMentorList()
                                    : Container(),
                                const SizedBox(
                                  height: 20,
                                ),
                                getMentorsReviewHeader(),
                                const SizedBox(
                                  height: 18,
                                ),
                                getMentorsReviewList(),
                                const SizedBox(
                                  height: 32,
                                ),
                                getStudentReviewHeader(),
                                const SizedBox(
                                  height: 18,
                                ),
                                getStudentReviewList(),
                                getInviteContainer(),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getInviteContainer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.inviteColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      "Invite your friends",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      width: 103,
                      child: AppText(
                        "and get 30% off on first session",
                        maxLines: 2,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    getInviteCTA(),
                  ],
                ),
              ),
              const Expanded(
                  child: AppImage(
                image: ImageAsset.invite,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget getInviteCTA() {
    return Container(
      width: 75,
      height: 27,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: AppColors.whiteColor),
      child: const Center(
        child: AppText(
          "Invite now",
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<StudentReview> listOfStudentReview = StudentReview.listOfStudentReview;

  Widget getStudentReviewList() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listOfStudentReview.length,
        itemBuilder: (context, index) => getStudentReviewView(index),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 6,
        ),
      ),
    );
  }

  Widget getStudentReviewView(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 170,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 30,
                    width: MediaQuery.of(context).size.width - 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: index % 2 == 0
                            ? AppColors.review_1
                            : AppColors.review_2),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(
                            listOfStudentReview[index].review ?? "",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                            letterSpacing: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: getStudentProfileImageForReview(index)),
        ],
      ),
    );
  }

  Widget getStudentProfileImageForReview(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Container(
          height: 45,
          width: 45,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            foregroundImage: listOfStudentReview[index].profileImageUrl != null
                ? NetworkImage(listOfStudentReview[index].profileImageUrl ?? "",
                    scale: 1)
                : null,
            child: listOfStudentReview[index].profileImageUrl == null
                ? const AppImage(
                    image: ImageAsset.blueAvatar,
                  )
                : CommonWidgets.getCircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget getStudentReviewHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: AppText(
        "Real stories from real students",
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  List<MentorsReview> listOfMentorsReview = MentorsReview.listOfMentorsReview;

  Widget getMentorsReviewList() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listOfMentorsReview.length,
        itemBuilder: (context, index) => getMentorsReviewView(index),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 6,
        ),
      ),
    );
  }

  Widget getMentorsReviewView(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: MediaQuery.of(context).size.height - 30,
          width: MediaQuery.of(context).size.width - 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: index % 2 == 0
                  ? AppColors.totalEarningColor
                  : AppColors.totalBookingsColor),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    getMentorsProfileImageForReview(index),
                    const SizedBox(
                      width: 10,
                    ),
                    AppText(
                      listOfMentorsReview[index].mentorName ?? "",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                AppText(
                  listOfMentorsReview[index].review ?? "",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getMentorsProfileImageForReview(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: AppColors.blackMerlin)),
        child: CircleAvatar(
          radius: 30.0,
          foregroundImage: listOfMentorsReview[index].profileImageUrl != null
              ? NetworkImage(profileImage)
              : null,
          child: listOfMentorsReview[index].profileImageUrl == null
              ? const AppImage(
                  image: ImageAsset.blueAvatar,
                )
              : CommonWidgets.getCircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getMentorsReviewHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: AppText(
        "What our mentors saying",
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget getNearbyMentorList() {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: lisOfTeachersDetails.length,
        itemBuilder: (context, index) => MentorDetailCard(
          mentorDetail: lisOfTeachersDetails[index],
        ),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 0,
        ),
      ),
    );
  }

  String assignTeacherTagForSession(int index) {
    String tagList = "";
    for (String element in lisOfTeachersDetails[index].tags!) {
      tagList = "$tagList$element,";
    }
    return tagList;
  }

  Widget getMentorDetailsView(int index) {
    String sessionTags = assignTeacherTagForSession(index);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: MediaQuery.of(context).size.width - 70,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.grey32),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getMentorsProfileImage(index),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  lisOfTeachersDetails[index].name ?? "",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText(
                              lisOfTeachersDetails[index].education ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            AppText(
                              lisOfTeachersDetails[index].title ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: AppText(
                                sessionTags,
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
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.mentorsAmountColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                AppText(
                                  "₹ ${lisOfTeachersDetails[index].sessionPricing?["session_type_a"]}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                const AppText(
                                  "/ 30 min session",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                AppText(
                                  "₹ ${lisOfTeachersDetails[index].sessionPricing?["session_type_b"]}",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                const AppText(
                                  "/ 15 min session",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => onBookSessionTap(index),
                          child: Container(
                            height: 52,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.cyanBlue),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  AppText(
                                    "Book Session",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const AppText(
                                  //       "Available in:",
                                  //       fontSize: 10,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: AppColors.whiteColor,
                                  //     ),
                                  //     getScheduleLeftTime(),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onBookSessionTap(int index) {
    Navigator.of(context).pushNamed(AppRoutes.bookSession,
        arguments: StudentSessionArgument(
            teacherId: lisOfTeachersDetails[index].teacherId));
  }

  Widget getMentorsProfileImage(int index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 100,
      child: lisOfTeachersDetails[index].profilePictureUrl == null
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: AppImage(
                  image: ImageAsset.blueAvatar,
                ),
              ),
            )
          : Image.network(
              lisOfTeachersDetails[index].profilePictureUrl ?? "",
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: AppImage(
                      image: ImageAsset.blueAvatar,
                    ),
                  ),
                );
              },
              fit: BoxFit.fill,
            ),
    );
  }

  Widget getNearByHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          AppText(
            "Nearby mentors",
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          AppText(
            "See all",
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget getNextSessionCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount:
              context.read<StudentHomeBloc>().listOfUpcomingSessions.length > 3
                  ? 2
                  : context
                      .read<StudentHomeBloc>()
                      .listOfUpcomingSessions
                      .length,
          itemBuilder: (context, index, realIndex) {
            return getNextSessionView(index);
          },
          options: CarouselOptions(
              height: 136,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              autoPlay: true,
              onPageChanged: (curIndex, reason) {
                BlocProvider.of<StudentHomeBloc>(context)
                    .add(UpdatedNextSessionIndexEvent(nextIndex: curIndex));
              }),
        ),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex:
                context.read<StudentHomeBloc>().currentNextSessionIndex,
            count:
                context.read<StudentHomeBloc>().listOfUpcomingSessions.length,
            onDotClicked: (dotIndex) {
              BlocProvider.of<StudentHomeBloc>(context)
                  .add(UpdatedNextSessionIndexEvent(nextIndex: dotIndex));
            },
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.cyanBlue,
              dotColor: AppColors.grey32,
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 2,
              strokeWidth: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget getNextSessionView(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.strongCyan,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context
                            .read<StudentHomeBloc>()
                            .listOfUpcomingSessions[index]
                            .agenda ??
                        "",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(
                    "Next session with ${context.read<StudentHomeBloc>().listOfUpcomingSessions[index].teacherDetail?.name ?? ""}",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AppText(
                            "${DateTimeUtils.getBirthFormattedDateTime(context.read<StudentHomeBloc>().listOfUpcomingSessions[index].startDate ?? DateTime.now())} ${DateTimeUtils.getTimeInAMOrPM(context.read<StudentHomeBloc>().listOfUpcomingSessions[index].startDate ?? DateTime.now())}",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  const AppText(
                                    "In",
                                    fontWeight: FontWeight.w700,
                                  ),
                                  getScheduleLeftTime(),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget getFindMentorSearchWidget() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.searchMentor);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: const [
                AppImage(image: ImageAsset.search),
                SizedBox(
                  height: 13,
                ),
                Expanded(
                    child: AppText(
                  "Search ’EXAM NAME’",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey55,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getFindMentorHeader() {
    return const AppText(
      AppStrings.findMentor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
  }

  Widget getProfileWidget() {
    return Row(
      children: [
        getProfileImage(),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getStudentName(),
                  getLocation(),
                ],
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.notificationRoute);
                  },
                  child: const AppImage(image: ImageAsset.notification)),
            ],
          ),
        )
      ],
    );
  }

  Widget getLocation() {
    return Row(
      children: [
        AppText(
          studentDetail?.location ?? "",
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 15,
        ),
      ],
    );
  }

  Widget getStudentName() {
    return AppText(
      "Hi ${studentDetail?.name ?? "Guest"}",
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  String profileImage =
      "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=";

  onProfileTap() {
    Navigator.of(context).pushNamed(AppRoutes.studentProfile);
  }

  Widget getProfileImage() {
    return GestureDetector(
      onTap: () => onProfileTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: SizedBox(
          height: 44,
          width: 44,
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
      ),
    );
  }

  Widget getScheduleLeftTime() {
    int timeLeftInSeconds = getLeftTimeInSeconds(DateTime(2024));
    return SlideCountdown(
      duration: Duration(seconds: timeLeftInSeconds),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      slideDirection: SlideDirection.down,
      durationTitle: DurationTitle.id(),
      separator: ":",
      textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.blackMerlin),
      separatorStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.blackMerlin),
    );
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  void assignListOfTags() {}
}

class CoachMarker extends StatefulWidget {
  const CoachMarker(
      {super.key,
      required this.text,
      this.next = "Next",
      this.skip = "Skip",
      this.onNext,
      this.onSkip});

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachMarker> createState() => _CoachMarkerState();
}

class _CoachMarkerState extends State<CoachMarker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: AppColors.cyanBlue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 185,
              child: const AppText(
                "Find a best mentor for you by searching with a exam name",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
                maxLines: 2,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            getFindMentorSearchWidget(),
            const SizedBox(
              height: 20,
            ),
            getGotItButton(),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  Widget getScheduleLeftTime(int index) {
    int timeLeftInSeconds = getLeftTimeInSeconds(context
            .read<StudentHomeBloc>()
            .listOfUpcomingSessions[index]
            .startDate ??
        DateTime.now());
    return SlideCountdown(
      duration: Duration(seconds: timeLeftInSeconds),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      slideDirection: SlideDirection.down,
      durationTitle: DurationTitle.id(),
      separator: ":",
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      separatorStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }

  Widget getGotItButton() {
    return GestureDetector(
      onTap: () => widget.onSkip,
      child: Container(
        height: 34,
        width: 82,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: AppText(
            "Got it",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        )),
      ),
    );
  }

  Widget getFindMentorSearchWidget() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: const [
              AppImage(image: ImageAsset.search),
              SizedBox(
                height: 13,
              ),
              Expanded(
                  child: AppText(
                "Search mentors by exam name",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.grey55,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
