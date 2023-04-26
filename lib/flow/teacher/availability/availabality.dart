import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/availability/availability_calender.dart';
import 'package:newversity/flow/teacher/availability/date_slot_availability_route.dart';

import '../../../common/common_widgets.dart';
import '../../../resources/images.dart';
import '../../../themes/colors.dart';
import 'availability_bloc/availability_bloc.dart';

class Availability extends StatefulWidget {
  const Availability({Key? key}) : super(key: key);

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  bool isCalenderView = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: context.read<AvailabilityBloc>().isCalenderView
              ? Container()
              : FloatingActionButton(
                  onPressed: () {
                    context
                        .read<AvailabilityBloc>()
                        .add(UpdateAvailabilityPageEvent());
                  },
                  backgroundColor: AppColors.cyanBlue,
                  child: const Icon(
                    Icons.add,
                    color: AppColors.whiteColor,
                  ),
                ),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: AppColors.whiteColor),
                ),
                Column(
                  children: [
                    getAppHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        primary: true,
                        child:
                            BlocConsumer<AvailabilityBloc, AvailabilityState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                context.read<AvailabilityBloc>().isCalenderView
                                    ? const AvailabilityRoute()
                                    : const DateWiseAvailabilityRoute(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onCalenderViewTap() {
    context.read<AvailabilityBloc>().add(UpdateAvailabilityPageEvent());
  }

  Widget getAppHeader() {
    return Container(
      color: AppColors.lightCyan,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              "Availability",
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            InkWell(
              onTap: () => onCalenderViewTap(),
              child: AppImage(
                  image: context.read<AvailabilityBloc>().isCalenderView
                      ? ImageAsset.calenderUp
                      : ImageAsset.calenderIcon),
            ),
          ],
        ),
      ),
    );
  }
}
