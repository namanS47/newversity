import 'package:flutter/material.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../navigation/app_routes.dart';
import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';
import '../../../../../themes/strings.dart';
import '../../model/profile_dashboard_arguments.dart';

class ProfileCompletenessBottomSheet extends StatefulWidget {
  final String reason;
  final bool isStudent;
  const ProfileCompletenessBottomSheet(
      {Key? key, required this.reason, required this.isStudent})
      : super(key: key);

  @override
  State<ProfileCompletenessBottomSheet> createState() =>
      _ProfileCompletenessBottomSheetState();
}

class _ProfileCompletenessBottomSheetState
    extends State<ProfileCompletenessBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 400,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 5,
                      width: 46,
                      decoration: BoxDecoration(
                          color: AppColors.grey32,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const AppImage(image: ImageAsset.profileCompleteInfo),
                    const SizedBox(
                      height: 16,
                    ),
                    const AppText(
                      "Your profile is looking incomplete!",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                      widget.reason,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appYellow,
                    ),
                  ],
                ),
              ),
              getProfileCompleteCTA(),
            ],
          ),
        ),
      ),
    );
  }

  onProfileCompletenessTap() async {
    if (widget.isStudent) {
      await Navigator.of(context).pushNamed(AppRoutes.editProfile);
    } else {
      Navigator.of(context).pushNamed(AppRoutes.teacherProfileDashBoard,
          arguments: ProfileDashboardArguments(
              directedIndex: 1, showBackButton: true));
    }
  }

  Widget getProfileCompleteCTA() {
    return AppCta(
      text: AppStrings.completeProfile,
      onTap: () => onProfileCompletenessTap(),
    );
  }
}
