import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/navigation/app_routes.dart';

import '../../../../resources/images.dart';
import '../../../../themes/colors.dart';

class StudentProfileLocation extends StatefulWidget {
  const StudentProfileLocation({Key? key}) : super(key: key);

  @override
  State<StudentProfileLocation> createState() => _StudentProfileLocationState();
}

class _StudentProfileLocationState extends State<StudentProfileLocation> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getFindMentorHeader(),
          const SizedBox(
            height: 20,
          ),
          getSearchHeader(),
          const SizedBox(
            height: 10,
          ),
          getFindMentorSearchWidget(),
          const SizedBox(
            height: 20,
          ),
          Align(alignment: Alignment.bottomCenter, child: getNextCTA()),
        ],
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
            children: [
              const AppImage(image: ImageAsset.search),
              const SizedBox(
                width: 13,
              ),
              Expanded(
                  child: AppTextFormField(
                controller: _searchController,
                hintText: "search’",
                hintTextStyle: const TextStyle(color: AppColors.blackMerlin, fontSize: 16),
                decoration: const InputDecoration(border: InputBorder.none),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget getSearchHeader() {
    return const AppText(
      "Search for your city",
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  Widget getFindMentorHeader() {
    return const AppText(
      "Find a better mentor from your location",
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  Widget getNextCTA() {
    return AppCta(
      text: "Next",
      onTap: () => onNextTap(),
    );
  }

  onNextTap() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.studentHome, (route) => false, arguments: true);
  }
}
