import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../home/model/session_details.dart';

class MentorSearchScreen extends StatefulWidget {
  const MentorSearchScreen({Key? key}) : super(key: key);

  @override
  State<MentorSearchScreen> createState() => _MentorSearchScreenState();
}

class _MentorSearchScreenState extends State<MentorSearchScreen> {
  List<MentorDetails> listOfMentorsDetails = MentorDetails.listOfMentorsDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            searchAppBar(),
            Container(
              height: 1,
              color: AppColors.grey32,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const AppText(
                      "Top searches",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    suggestionWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    const AppText(
                      "Recent searches",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    getRecentSearches()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> listOfSuggestions = [
    "JEE MAIN",
    "JEE ADVANCE",
    "NEET",
    "NIT",
    "OLYMPIAD",
    "IIT"
  ];

  Widget getRecentSearches() {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listOfMentorsDetails.length,
        itemBuilder: (context, index) => getMentorDetailsView(index),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 6,
        ),
      ),
    );
  }

  Widget suggestionWidget() {
    return Wrap(
        runSpacing: 15,
        spacing: 12,
        children: List.generate(
            listOfSuggestions.length, (index) => getSuggestionView(index)));
  }

  Widget getSuggestionView(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const AppImage(
              image: ImageAsset.search,
              width: 25,
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            AppText(
              listOfSuggestions[index],
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey55,
            ),
          ],
        ),
        const AppImage(image: ImageAsset.icSuggestion),
      ],
    );
  }

  Widget getMentorsProfileImage(int index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 100,
      child: listOfMentorsDetails[index].profileImageUrl == null
          ? const AppImage(
              image: ImageAsset.blueAvatar,
            )
          : Image.network(
              listOfMentorsDetails[index].profileImageUrl ?? "",
              fit: BoxFit.fill,
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
          fontWeight: FontWeight.w400,
          color: AppColors.whiteColor),
      separatorStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.whiteColor),
    );
  }

  int getLeftTimeInSeconds(DateTime dateTime) {
    return (dateTime.difference(DateTime.now()).inSeconds);
  }

  Widget getRateContainer(int index) {
    return Container(
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
            Text(
              listOfMentorsDetails[index].rating.toString(),
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  Widget getMentorDetailsView(int index) {
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
                                  listOfMentorsDetails[index].name ?? "",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                getRateContainer(index),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText(
                              listOfMentorsDetails[index].college ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            AppText(
                              listOfMentorsDetails[index].designation ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 220,
                              child: AppText(
                                listOfMentorsDetails[index].certificates ?? "",
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
                              children: const [
                                AppText(
                                  "₹ 250",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                AppText(
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
                              children: const [
                                AppText(
                                  "₹ 150",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                AppText(
                                  "/ 15 min session",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.cyanBlue),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AppText(
                                  "Book Session",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                ),
                                Row(
                                  children: [
                                    const AppText(
                                      "Available in:",
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.whiteColor,
                                    ),
                                    getScheduleLeftTime(),
                                  ],
                                ),
                              ],
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

  Widget searchAppBar() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: const [
            AppImage(
              image: ImageAsset.close,
              height: 32,
              width: 32,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: AppTextFormField(
                hintTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                hintText: "Search exam name",
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
