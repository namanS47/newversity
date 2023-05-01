import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/flow/teacher/index/view/bottom_sheet/contact_us.dart';
import 'package:newversity/navigation/app_routes.dart';

import '../../../../resources/images.dart';
import '../../../../themes/colors.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children:  [
                  InkWell(
                    onTap: ()=>{
                      Navigator.pop(context)
                    },
                      child: const AppImage(image: ImageAsset.arrowBack)),
                  const SizedBox(
                    width: 10,
                  ),
                  const AppText(
                    "Help and Support",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const AppText(
                "We are here to resolve your all queries",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 30,
              ),
              getFaqsContainer(),
              const SizedBox(
                height: 20,
              ),
              getConnectContainer(),
              const SizedBox(
                height: 20,
              ),
              getIssueRaiseContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getIssueRaiseContainer() {
    return GestureDetector(
      onTap: () => onTapOfRaiseIssueContainer(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppText(
                "Raise an issue",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              AppImage(
                image: ImageAsset.arrowForward,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTapOfRaiseIssueContainer() {
    Navigator.of(context).pushNamed(AppRoutes.raiseIssueRoute,arguments: SessionDetailArguments(id: "", isPrevious: false));
  }

  onTapOfFaqsContainer() {
    Navigator.of(context).pushNamed(AppRoutes.faqs);
  }

  Widget getFaqsContainer() {
    return GestureDetector(
      onTap: () => onTapOfFaqsContainer(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppText(
                "FAQs",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              AppImage(
                image: ImageAsset.arrowForward,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTapOfConnectContainer() {
    showModalBottomSheet<dynamic>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (_) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AppAnimatedBottomSheet(bottomSheetWidget: ContactUsScreen()),
          );
          // your stateful widget
        });
  }

  Widget getConnectContainer() {
    return GestureDetector(
      onTap: () => onTapOfConnectContainer(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                "Wants to connect with us?",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                onTap: () => onTapOfConnectContainer(),
                child: const AppText(
                  "contact us",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
