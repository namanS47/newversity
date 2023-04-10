import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/index/bloc/faqs_bloc/faqs_bloc.dart';

import '../../../../resources/images.dart';
import '../../../../themes/colors.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({Key? key}) : super(key: key);

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  AppImage(image: ImageAsset.arrowBack),
                  SizedBox(
                    width: 10,
                  ),
                  AppText(
                    "FAQ",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              getSearchWidget(),
              Expanded(
                child: BlocConsumer<FaqsBloc, FaqsStates>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: getCustomizeExpandedView(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCustomizeExpandedView() {
    return Wrap(
      spacing: 30,
      children: List.generate(
        context.read<FaqsBloc>().data.length,
        (curIndex) {
          return getCustomizeExpandedLayout(curIndex);
        },
      ),
    );
  }

  onExpandTap(int index) {
    BlocProvider.of<FaqsBloc>(context).add(OnFaqExpandEvent(index: index));
  }

  Widget getCustomizeExpandedLayout(int index) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.whiteColor),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () => onExpandTap(index),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      context
                              .read<FaqsBloc>()
                              .data[index]
                              .questionAnsModel
                              .question ??
                          "",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    context.read<FaqsBloc>().data[index].isExpanded
                        ? const Icon(
                            Icons.remove,
                            size: 20,
                            color: AppColors.blackMerlin,
                          )
                        : const Icon(
                            Icons.add,
                            size: 20,
                            color: AppColors.blackMerlin,
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              context.read<FaqsBloc>().data[index].isExpanded
                  ? AppText(context
                          .read<FaqsBloc>()
                          .data[index]
                          .questionAnsModel
                          .answer ??
                      "")
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.grey35,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getSearchWidget() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(52),
        color: AppColors.whiteColor,
        border: Border.all(width: 0.9, color: AppColors.dividerColor),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const AppImage(image: ImageAsset.search),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) => onSearchText(),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search ' FAQs '",
                      hintStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSearchText() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    FocusScope.of(context).unfocus();
    BlocProvider.of<FaqsBloc>(context)
        .add(SearchFaqsEvents(searchedText: _searchController.text));
  }
}
