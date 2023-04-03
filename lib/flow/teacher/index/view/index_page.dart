import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/index/view/profile_drawer_screen.dart';
import 'package:newversity/themes/colors.dart';

import '../bloc/index_bloc.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IndexBloc, IndexState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          key: context.read<IndexBloc>().scaffoldKey,
          resizeToAvoidBottomInset: false,
          endDrawer: const SizedBox(width: 240, child: ProfileDrawerScreen()),
          drawerEnableOpenDragGesture: true,
          bottomNavigationBar: Row(
            children: List.generate(
              context.read<IndexBloc>().indexPages.length,
              (index) => getBottomNavigationBarItems(index),
            ),
          ),
          body: context
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
        BlocProvider.of<IndexBloc>(context)
            .add(IndexPageUpdateEvent(index: index));
      },
      child: Container(
        height: 74,
        width: MediaQuery.of(context).size.width / 3,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 28.0),
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
                    image: context
                        .read<IndexBloc>()
                        .pagesNameWithImageIcon[index]['image'],
                    color: context.read<IndexBloc>().selectedIndex == index
                        ? AppColors.primaryColor
                        : AppColors.cyanBlue,
                    height: context.read<IndexBloc>().selectedIndex == index
                        ? 22
                        : 20,
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    context.read<IndexBloc>().pagesNameWithImageIcon[index]
                        ['name']!,
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
      ),
    );
  }
}
