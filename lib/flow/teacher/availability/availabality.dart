import 'package:flutter/material.dart';
import 'package:newversity/flow/teacher/availability/availability_calender.dart';
import 'package:newversity/flow/teacher/availability/date_slot_availability_route.dart';

import '../../../common/common_widgets.dart';
import '../../../resources/images.dart';
import '../../../themes/colors.dart';

class Availability extends StatefulWidget {
  const Availability({Key? key}) : super(key: key);

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  bool isCalenderView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: AppColors.lightCyan),
            ),
            Column(
              children: [
                getAppHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    primary: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        isCalenderView
                            ? const AvailabilityRoute()
                            : const DateWiseAvailabilityRoute(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: const AppImage(image: ImageAsset.arrowBack)),
              const SizedBox(
                width: 10,
              ),
              const AppText(
                "Availability",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
        ],
      ),
    );
  }
}
