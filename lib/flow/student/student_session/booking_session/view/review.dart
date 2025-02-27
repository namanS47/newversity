import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';
import '../../../../teacher/profile/model/review_data.dart';

class SessionReview extends StatelessWidget {
  SessionReview({Key? key}) : super(key: key);

  // final double _userRating = 4.1;
  List<ReviewData> listOfReviewData = ReviewData.listOfReview;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            getReviewsHeading(),
            const SizedBox(
              height: 5,
            ),
            // getRatingContainer(),
            const SizedBox(
              height: 5,
            ),
            getReviewLayout(context)
          ],
        ),
      ),
    );
  }

  Widget getReviewLayout(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 5,
      children: List.generate(
        listOfReviewData.length,
        (curIndex) {
          return getReviewContainer(curIndex, context);
        },
      ),
    );
  }

  Widget getReviewContainer(int index, BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 34,
                    width: 34,
                    child: CircleAvatar(
                      radius: 200,
                      child: AppImage(
                        image: ImageAsset.blueAvatar,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              listOfReviewData[index].name ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              listOfReviewData[index].reviewDate ?? "",
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        AppText(
                          listOfReviewData[index].qualification ?? "",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              AppText(
                listOfReviewData[index].reviewHeadLine ?? "",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 10,
              ),
              AppText(
                listOfReviewData[index].review ?? "",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ));
  }

  // Widget getRatingContainer() {
  //   return Container(
  //     height: 100,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(14.0),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               children: [
  //                 AppText(
  //                   "$_userRating",
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //                 const SizedBox(
  //                   height: 5,
  //                 ),
  //                 RatingBarIndicator(
  //                   rating: _userRating,
  //                   itemBuilder: (context, index) => const Icon(
  //                     Icons.star,
  //                     color: Colors.amber,
  //                   ),
  //                   itemCount: 5,
  //                   itemSize: 9.0,
  //                   unratedColor: Colors.amber.withAlpha(50),
  //                 ),
  //                 const SizedBox(
  //                   height: 5,
  //                 ),
  //                 const AppText(
  //                   "total 150 session",
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(
  //             width: 10,
  //           ),
  //           Expanded(child: Container())
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget getReviewsHeading() {
    return const AppText(
      "Reviews",
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
  }
}
