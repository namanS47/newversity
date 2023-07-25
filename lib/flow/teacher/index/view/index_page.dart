import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/event_broadcast.dart';

import '../../profile/model/profile_completion_percentage_response.dart';
import '../bloc/index_bloc.dart';

class IndexPage extends StatefulWidget {
  final bool isStudent;
  const IndexPage({Key? key, required this.isStudent}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  ProfileCompletionPercentageResponse? profileCompletionPercentageResponse;

  @override
  void initState() {
    super.initState();

    EventsBroadcast.get().on().listen((event) {
      if(event is ChangeHomePageIndexEvent) {
        context.read<IndexBloc>().add(IndexPageUpdateEvent(index: event.index));
      }
    });

    // if (!widget.isStudent) {
    //   BlocProvider.of<IndexBloc>(context)
    //       .add(FetchTeacherProfileCompletenessPercentageEvent());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IndexBloc, IndexState>(
      listener: (context, state) {
        if (state is FetchedProfileCompletionInfoState) {
          profileCompletionPercentageResponse =
              state.profileCompletionPercentageResponse;
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: Row(
            children: List.generate(
              widget.isStudent
                  ? context.read<IndexBloc>().studentIndexPage.length
                  : context.read<IndexBloc>().indexPages.length,
              (index) => getBottomNavigationBarItems(index),
            ),
          ),
          body: widget.isStudent
              ? IndexedStack(
                  index: context.read<IndexBloc>().selectedIndex,
                  children: context.read<IndexBloc>().studentIndexPage,
                )
              : context
                  .read<IndexBloc>()
                  .indexPages
                  .elementAt(context.read<IndexBloc>().selectedIndex),
        );
      },
    );
  }

  Widget getBottomNavigationBarItems(int index) {
    return GestureDetector(
      onTap: () {
        if (profileCompletionPercentageResponse?.completePercentage == 0) {
          CommonWidgets.showProfileIncompletenessBottomSheet(
              context,
              profileCompletionPercentageResponse ??
                  ProfileCompletionPercentageResponse(),
              widget.isStudent);
        } else {
          BlocProvider.of<IndexBloc>(context)
              .add(IndexPageUpdateEvent(index: index));
        }
      },
      child: Container(
        height: 74,
        width: MediaQuery.of(context).size.width /
            (widget.isStudent
                ? context.read<IndexBloc>().studentIndexPage.length
                : context.read<IndexBloc>().indexPages.length),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
        ),
        child: Column(
          children: [
            context.read<IndexBloc>().selectedIndex == index
                ? Center(
                    child: Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(height: 5),
            const SizedBox(height: 10),
            Column(
              children: [
                AppImage(
                  image: widget.isStudent
                      ? context
                              .read<IndexBloc>()
                              .studentPagesNameWithImageIcon[index]['image'] ??
                          ""
                      : context.read<IndexBloc>().pagesNameWithImageIcon[index]
                              ['image'] ??
                          "",
                  color: context.read<IndexBloc>().selectedIndex == index
                      ? AppColors.primaryColor
                      : AppColors.cyanBlue,
                  height: context.read<IndexBloc>().selectedIndex == index
                      ? 22
                      : 20,
                ),
                const SizedBox(height: 6),
                AppText(
                  widget.isStudent
                      ? context
                              .read<IndexBloc>()
                              .studentPagesNameWithImageIcon[index]['name'] ??
                          ""
                      : context.read<IndexBloc>().pagesNameWithImageIcon[index]
                              ['name'] ??
                          "",
                  color: context.read<IndexBloc>().selectedIndex == index
                      ? AppColors.primaryColor
                      : AppColors.cyanBlue,
                  fontSize: context.read<IndexBloc>().selectedIndex == index
                      ? 12
                      : 12,
                  fontWeight: context.read<IndexBloc>().selectedIndex == index
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
