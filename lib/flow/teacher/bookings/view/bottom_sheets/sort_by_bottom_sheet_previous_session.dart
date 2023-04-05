import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/bookings/bloc/previous_section_bloc/previous_session_bloc.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../themes/colors.dart';

class SortByForPreviousSessionBottomSheet extends StatefulWidget {
  const SortByForPreviousSessionBottomSheet({Key? key}) : super(key: key);

  @override
  State<SortByForPreviousSessionBottomSheet> createState() =>
      _SortByForPreviousSessionBottomSheetState();
}

class _SortByForPreviousSessionBottomSheetState
    extends State<SortByForPreviousSessionBottomSheet> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreviousSessionBloc, PreviousSessionStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 46,
                  decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: AppText(
                  "Sort By",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 1,
                decoration: const BoxDecoration(color: AppColors.grey32),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: getSortByLayout(),
              ),
              const SizedBox(
                height: 40,
              ),
              getBottomNabWidget()
            ],
          ),
        );
      },
    );
  }

  Widget getSortByView(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () => onTapRadioButton(index),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              context.read<PreviousSessionBloc>().sortBy[index],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: context
                                .read<PreviousSessionBloc>()
                                .selectedSortByIndex ==
                            index
                        ? AppColors.cyanBlue
                        : AppColors.grey50),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context
                                  .read<PreviousSessionBloc>()
                                  .selectedSortByIndex ==
                              index
                          ? AppColors.cyanBlue
                          : AppColors.whiteColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  onTapRadioButton(int index) {
    BlocProvider.of<PreviousSessionBloc>(context)
        .add(OnChangeSortByIndexEvent(index: index));
  }

  Widget getSortByLayout() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        context.read<PreviousSessionBloc>().sortBy.length,
        (curIndex) {
          return getSortByView(curIndex);
        },
      ),
    );
  }

  onResetTap() {
    BlocProvider.of<PreviousSessionBloc>(context)
        .add(OnChangeSortByIndexEvent(index: 0));
  }

  Widget getResetButton() {
    return InkWell(
      onTap: () => onResetTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.cyanBlue,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: AppText(
              "Reset",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  onApplyTap() {}

  Widget getApplyWidget() {
    return GestureDetector(
      onTap: () => onApplyTap(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.cyanBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: AppText(
              "Apply",
              color: AppColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget getBottomNabWidget() {
    return SizedBox(
      height: 82,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: getResetButton()),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: getApplyWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
