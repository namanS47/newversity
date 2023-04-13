import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';

import '../../../../../../themes/colors.dart';

class StudentReviewSheet extends StatefulWidget {
  const StudentReviewSheet({Key? key}) : super(key: key);

  @override
  State<StudentReviewSheet> createState() => _StudentReviewSheetState();
}

class _StudentReviewSheetState extends State<StudentReviewSheet> {
  bool showError = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 300,
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              )),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        "Give a review",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const AppText(
                        "please tell us your experience",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey55,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getReviewEditContainer(),
                      const SizedBox(
                        height: 10,
                      ),
                      showError
                          ? const AppText(
                              "Amount cannot be empty!",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.redColorShadow400,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              getBottomView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getReviewEditContainer() {
    return const AppTextFormField(
      maxLines: 5,
      hintText: "Review Description",
      hintTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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

  onSubmitTap() {}

  Widget getSubmitReviewCTA() {
    return GestureDetector(
      onTap: () => onSubmitTap(),
      child: Container(
        height: 50,
        width: 162,
        decoration: BoxDecoration(
            color: AppColors.cyanBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.cyanBlue)),
        child: const Center(
            child: AppText(
          "Submit Review",
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
              Expanded(child: getSubmitReviewCTA())
            ],
          ),
        ),
      ),
    );
  }
}
