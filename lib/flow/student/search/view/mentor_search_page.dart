import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

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
        itemBuilder: (context, index) =>
            MentorCard(mentorDetail: listOfMentorsDetails[index]),
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
        listOfSuggestions.length,
        (index) => getSuggestionView(index),
      ),
    );
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
