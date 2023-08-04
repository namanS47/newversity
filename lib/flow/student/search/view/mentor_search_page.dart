import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/search/bloc/mentor_search_bloc.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

import '../../../../common/mentor_detail_card.dart';

class MentorSearchScreen extends StatefulWidget {
  const MentorSearchScreen({Key? key, this.getAllMentors}) : super(key: key);

  final bool? getAllMentors;

  @override
  State<MentorSearchScreen> createState() => _MentorSearchScreenState();
}

class _MentorSearchScreenState extends State<MentorSearchScreen> {
  final _searchController = TextEditingController();
  Timer? getTagsBySearchKeywordEventTimer;

  @override
  void initState() {
    if (widget.getAllMentors == true) {
      context.read<MentorSearchBloc>().add(FetchAllMentorsListEvent());
    } else {
      context
          .read<MentorSearchBloc>()
          .add(GetTagsBySearchKeywordEvent(searchKeyword: ""));
    }

    super.initState();
  }

  void callGetTagsBySearchKeywordEvent(String val) {
    if (getTagsBySearchKeywordEventTimer != null) {
      getTagsBySearchKeywordEventTimer?.cancel();
    }
    getTagsBySearchKeywordEventTimer = Timer(
      const Duration(seconds: 1),
      () {
        context.read<MentorSearchBloc>().add(
              GetTagsBySearchKeywordEvent(
                searchKeyword: val.toString().toLowerCase(),
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            searchAppBar(context),
            Container(
              height: 1,
              color: AppColors.grey32,
            ),
            BlocConsumer<MentorSearchBloc, MentorSearchStates>(
              builder: (context, state) {
                if (state is FetchingTagBySearchKeywordFailureState) {
                  return const Center(
                      child: NoResultFoundScreen(
                    message: "Please check spelling or try different key words",
                  ));
                }
                if (state is FetchingTagBySearchKeywordLoadingState ||
                    state is FetchTeacherListByTagNameLoadingState) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is FetchTeacherListByTagNameSuccessState) {
                  if (state.teacherDetailsList.isNotEmpty) {
                    return getResultedTeacherListWidget(
                        state.teacherDetailsList);
                  } else {
                    return const Center(
                      child: NoResultFoundScreen(
                          message:
                              "No mentor is available for this tag, please try a different tag"),
                    );
                  }
                }
                if (state is FetchAllTeacherListSuccessState) {
                  if (state.teacherDetailsList.isNotEmpty) {
                    return getResultedTeacherListWidget(
                        state.teacherDetailsList);
                  } else {
                    return const Center(
                      child: NoResultFoundScreen(
                          message:
                              "No mentor is available for this tag, please try a different tag"),
                    );
                  }
                }
                return getSearchSuggestionWidget();
              },
              listener: (context, state) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget getResultedTeacherListWidget(
      List<TeacherDetailsModel> teacherDetailsList) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            AppText(
              "Search result (${teacherDetailsList.length.toString()})",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: teacherDetailsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: MentorDetailCard(
                        mentorDetail: teacherDetailsList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchSuggestionWidget() {
    if(context.read<MentorSearchBloc>().resultedTags.isEmpty) {
      return Container();
    }

    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Expertise",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackRussian),
                ),
                const SizedBox(
                  height: 16,
                ),
                Wrap(
                  runSpacing: 12,
                  spacing: 10,
                  children: List.generate(
                      context.read<MentorSearchBloc>().resultedTags.length,
                      (index) => getTagContainerWithIconWidget(index, context.read<MentorSearchBloc>().resultedTags[index]!)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    getTagsBySearchKeywordEventTimer?.cancel();
    _searchController.dispose();
  }

  Widget getTagContainerWithIconWidget(int index, String tagName) {
    return InkWell(
      onTap: () {
        _searchController.text = tagName;
        context
            .read<MentorSearchBloc>()
            .add(FetchTeacherListByTagNameEvent(tagName: tagName));
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whisperGrey,
          borderRadius: BorderRadius.circular(50)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageAsset.tagIcon(index % 10 + 1), width: 16, height: 16,),
            const SizedBox(width: 6,),
            Text(context.read<MentorSearchBloc>().resultedTags[index] ?? "", style:
              const TextStyle(fontWeight: FontWeight.w500, color: AppColors.cyanBlue),)
          ],
        ),
      ),
    );
  }

  Widget searchAppBar(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const AppImage(
              image: ImageAsset.close,
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: AppTextFormField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              hintTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black30),
              hintText: "Search exam name",
              autofocus: true,
              onSave: (value) {
                context.read<MentorSearchBloc>().add(
                    FetchTeacherListByTagNameEvent(
                        tagName: value.toString().toLowerCase()));
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) {
                getTagsBySearchKeywordEventTimer?.cancel();
                context.read<MentorSearchBloc>().add(
                    FetchTeacherListByTagNameEvent(
                        tagName: value.toString().toLowerCase()));
              },
              onChange: callGetTagsBySearchKeywordEvent,
            ),
          )
        ],
      ),
    );
  }
}
