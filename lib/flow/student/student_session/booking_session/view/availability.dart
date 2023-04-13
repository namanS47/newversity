import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/themes/colors.dart';

import '../../../../../themes/strings.dart';
import '../../model/experience_data.dart';

class SessionAvailability extends StatefulWidget {
  const SessionAvailability({Key? key}) : super(key: key);

  @override
  State<SessionAvailability> createState() => _SessionAvailabilityState();
}

class _SessionAvailabilityState extends State<SessionAvailability> {
  int selectedSlot = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getAvailableSlotHeader(),
        const SizedBox(
          height: 10,
        ),
        getAvailableSlotLayout(),
        const SizedBox(
          height: 20,
        ),
        getAvailableTimeHeader(),
        const SizedBox(
          height: 10,
        ),
        getPerSessionRate(),
        const SizedBox(
          height: 20,
        ),
        getSessions(),
        const SizedBox(height: 20,),
        getNotificationChecker(),
        const SizedBox(height: 10,),
        getNextAvailable(),
        const SizedBox(height: 120,),
      ],
    );
  }

  Widget getNextAvailable(){
    return const Center(
      child: AppText(AppStrings.nextAvailable,
          fontSize: 12,
          color: AppColors.strongCyan,
          fontWeight: FontWeight.w500),
    );
  }

  bool isNotificationChecked = false;
  Widget getNotificationChecker(){
    return Row(
      children: [
        Checkbox(value: isNotificationChecked, onChanged: (bool? val){
        isNotificationChecked = val!;
        setState(() {
        });
        }),
        const SizedBox(width: 10,),
        const Text(AppStrings.notificationChecker,style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500
        ),)
      ],
    );
  }

  List<SessionData> sessions = SessionData.fifteenMinSessions;

  Widget getSessions() {
    return ListView.separated(
      padding: const EdgeInsets.only(right: 16, top: 5),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: sessions.length,
      itemBuilder: (context, index) => getSessionTimingLayout(index),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
    );
  }

  Widget getSessionTimingLayout(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${sessions[index].sessionDuration}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            sessions[index].sessionTiming != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 12,
                      children: List.generate(
                        sessions[index].sessionTiming!.length,
                        (curIndex) {
                          return getSessionTimingView(
                              sessions[index].sessionTiming![curIndex],
                              curIndex);
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  int selectedSession = -1;

  onSelectedSession(int index){
    selectedSession = index;
    setState(() {
    });
  }

  Widget getSessionTimingView(String sessionData, int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onSelectedSession(index),
          child: Container(
            height: 34,
            width: 83,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: selectedSession == index
                    ? AppColors.lightCyan
                    : AppColors.grey35,
                border: Border.all(width: 0.3, color: AppColors.grey32)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                sessionData,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget getPerSessionRate() {
    return Row(
      children: const [
        Text(
          AppStrings.perSession,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          AppStrings.twoFifty,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  bool switchEnable = false;

  Widget getAvailableTimeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          AppStrings.availableTime,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text(
              AppStrings.fifteenMin,
              style: TextStyle(
                  color:
                      switchEnable ? AppColors.grey32 : AppColors.blackMerlin,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 5,
            ),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                  value: switchEnable,
                  trackColor: AppColors.grey35,
                  thumbColor: AppColors.blackMerlin,
                  activeColor: AppColors.grey35,
                  onChanged: (val) {
                    switchEnable = val;
                    if (!switchEnable) {
                      sessions = SessionData.fifteenMinSessions;
                    } else {
                      sessions = SessionData.thirtyMinSession;
                    }

                    setState(() {});
                  }),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              AppStrings.thirtyMin,
              style: TextStyle(
                  color:
                      switchEnable ? AppColors.blackMerlin : AppColors.grey32,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  List<SlotData> slotData = SlotData.slotData;

  Widget getAvailableSlotLayout() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 16, top: 5),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: slotData.length,
        itemBuilder: (context, index) => getSlotDataView(index),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 30),
      ),
    );
  }

  onSlotSelected(int index) {
    selectedSlot = index;
    setState(() {});
  }

  Widget getSlotDataView(int index) {
    return GestureDetector(
      onTap: () => onSlotSelected(index),
      child: Center(
        child: Container(
          height: 104,
          width: 104,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: selectedSlot == index
                    ? AppColors.blackMerlin
                    : AppColors.grey32),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${slotData[index].slotDay}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${slotData[index].slotDate}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 104,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15.0)),
                    color: slotData[index].slotDuration != null
                        ? AppColors.strongGreen.withOpacity(0.12)
                        : AppColors.strongRed.withOpacity(0.12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Center(
                      child: Text(
                        slotData[index].slotDuration != null
                            ? "${slotData[index].slotDuration}"
                            : "No slot",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: slotData[index].slotDuration != null
                                ? AppColors.strongGreen
                                : AppColors.strongRed),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  tapOnSeeAll(){
    showDialog(
        context: context,
        builder: (_) {
          return const ShowSfCalenderWidget();
        });
  }

  Widget getAvailableSlotHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          AppStrings.availableSlot,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        InkWell(
          child: Text(
            AppStrings.seeAll,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class ShowSfCalenderWidget extends StatefulWidget {
  const ShowSfCalenderWidget({Key? key}) : super(key: key);

  @override
  State<ShowSfCalenderWidget> createState() => _ShowSfCalenderWidgetState();
}

class _ShowSfCalenderWidgetState extends State<ShowSfCalenderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

