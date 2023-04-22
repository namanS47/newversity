import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/search/bloc/mentor_search_bloc.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

import '../../../../common/mentor_detail_card.dart';

class MentorSearchScreen extends StatefulWidget {
  const MentorSearchScreen({Key? key}) : super(key: key);

  @override
  State<MentorSearchScreen> createState() => _MentorSearchScreenState();
}

class _MentorSearchScreenState extends State<MentorSearchScreen> {
  @override
  void initState() {
    context
        .read<MentorSearchBloc>()
        .add(GetTagsBySearchKeywordEvent(searchKeyword: ""));
    super.initState();
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
                if (state is FetchingTagBySearchKeywordLoadingState) {
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
                              "No teacher is available for this tag, please try a different tag"),
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

  Widget getResultedTeacherListWidget(List<TeacherDetails> teacherDetailsList) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: teacherDetailsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: MentorDetailCard(mentorDetail: teacherDetailsList[index]),
          );
        },
      ),
    );
  }

  Widget getSearchSuggestionWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return getSuggestionView(
                context.read<MentorSearchBloc>().resultedTags[index]);
          },
          itemCount: context.read<MentorSearchBloc>().resultedTags.length,
        ),
      ),
    );
  }

  Widget getTopSearchedWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            const AppText(
              "Top searches",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 20,
            ),
            getSearchSuggestionWidget(),
          ],
        ),
      ),
    );
  }

  Widget getSuggestionView(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12),
      child: InkWell(
        onTap: () {
          context
              .read<MentorSearchBloc>()
              .add(FetchTeacherListByTagNameEvent(tagName: text));
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: AppText(
                text,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.colorBlack,
                overflow: TextOverflow.clip,
              ),
            ),
            const AppImage(image: ImageAsset.icSuggestion),
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
              hintTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black30),
              hintText: "Search exam name",
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onChange: (value) {
                context
                    .read<MentorSearchBloc>()
                    .add(GetTagsBySearchKeywordEvent(searchKeyword: value));
              },
            ),
          )
        ],
      ),
    );
  }
}
