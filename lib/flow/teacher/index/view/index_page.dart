import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/themes/colors.dart';

import '../bloc/index_bloc.dart';

class IndexPage extends StatefulWidget {
  final bool isStudent;
  const IndexPage({Key? key, required this.isStudent}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IndexBloc, IndexState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Row(
            children: List.generate(
              widget.isStudent
                  ? context.read<IndexBloc>().studentIndexPage.length
                  : context.read<IndexBloc>().indexPages.length,
              (index) => getBottomNavigationBarItems(index),
            ),
          ),
          body: widget.isStudent
              ? context
                  .read<IndexBloc>()
                  .studentIndexPage
                  .elementAt(context.read<IndexBloc>().selectedIndex)
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
        BlocProvider.of<IndexBloc>(context)
            .add(IndexPageUpdateEvent(index: index));
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
                  image: widget.isStudent ?? true
                      ? context
                                  .read<IndexBloc>()
                                  .studentPagesNameWithImageIcon[index]
                              ['image'] ??
                          ""
                      : context
                              .read<IndexBloc>()
                              .pagesNameWithImageIcon[index]['image'] ??
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
                  widget.isStudent ?? true
                      ? context
                              .read<IndexBloc>()
                              .studentPagesNameWithImageIcon[index]['name'] ??
                          ""
                      : context
                              .read<IndexBloc>()
                              .pagesNameWithImageIcon[index]['name'] ??
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
