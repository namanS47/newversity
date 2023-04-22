import 'package:flutter/cupertino.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/themes/colors.dart';

import '../flow/teacher/profile/model/profile_dashboard_arguments.dart';
import '../navigation/app_routes.dart';

class CompleteProfileCard extends StatefulWidget {
  double profilePercentage;
  CompleteProfileCard({Key? key, required this.profilePercentage})
      : super(key: key);

  @override
  State<CompleteProfileCard> createState() => _CompleteProfileCardState();
}

class _CompleteProfileCardState extends State<CompleteProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              widget.profilePercentage != 0
                  ? "Complete your onboarding to get approval"
                  : "Your Profile is Looking empty",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor,
            ),
            const SizedBox(
              height: 4,
            ),
            const AppText(
              "Add some details and personalize your experience.\n Complete it now and start enjoying our app!",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.whiteColor,
            ),
            const SizedBox(
              height: 14,
            ),
            GestureDetector(
              onTap: () => _onConfirmTap(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      AppText(
                        "Complete profile",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onConfirmTap() {
    Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard,
        arguments:
            ProfileDashboardArguments(directedIndex: 1, showBackButton: true));
  }
}
