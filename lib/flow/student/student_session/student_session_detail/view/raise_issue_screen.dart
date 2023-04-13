import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';

import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';

class RaiseIssueScreen extends StatefulWidget {
  const RaiseIssueScreen({Key? key}) : super(key: key);

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  List<String> reasons = [
    "Couldn't connect call",
    "Network issue",
    "Very low sound",
    "Session was not helpful"
  ];

  List<String> selectedReason = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13),
              child: SingleChildScrollView(
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const AppImage(image: ImageAsset.arrowBack)),
                      const SizedBox(
                        height: 40,
                      ),
                      const Center(
                        child: AppImage(
                          image: ImageAsset.chatBot,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                          child: AppText(
                        "Raise an issue",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(child: getReasonListLayout()),
                      const SizedBox(
                        height: 20,
                      ),
                      getOtherIssueEditContainer(),
                    ],
                  ),
                ),
              ),
            )),
            getBottomView()
          ],
        ),
      ),
    );
  }

  Widget getOtherIssueEditContainer() {
    return const AppTextFormField(
      hintText: "mention your other issue...",
      maxLines: 10,
      hintTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget getReasonListLayout() {
    return Wrap(
      runSpacing: 15,
      spacing: 20,
      children: List.generate(reasons.length, (index) => getReasonView(index)),
    );
  }

  onReasonSelected(int index) {
    if (selectedReason.contains(reasons[index])) {
      selectedReason.remove(reasons[index]);
    } else {
      selectedReason.add(reasons[index]);
    }
    setState(() {});
  }

  Widget getReasonView(int index) {
    return GestureDetector(
      onTap: () => onReasonSelected(index),
      child: Container(
        decoration: BoxDecoration(
            color: selectedReason.contains(reasons[index])
                ? AppColors.primaryColor
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.grey35)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                reasons[index],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCancelCTA() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.cyanBlue)),
        child: const Center(
            child: AppText(
          "Cancel",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        )),
      ),
    );
  }

  onRaiseTicketTap() {}

  Widget getRaiseTicketCTA() {
    return GestureDetector(
      onTap: () => onRaiseTicketTap(),
      child: Container(
        height: 50,
        width: 162,
        decoration: BoxDecoration(
            color: AppColors.cyanBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.cyanBlue)),
        child: const Center(
            child: AppText(
          "Raise Ticket",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.whiteColor,
        )),
      ),
    );
  }

  Widget getBottomView() {
    return Card(
      elevation: 0,
      child: Container(
        height: 82,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey, //New
                blurRadius: 5.0,
                offset: Offset(0, -2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(child: getCancelCTA()),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: getRaiseTicketCTA())
            ],
          ),
        ),
      ),
    );
  }
}
