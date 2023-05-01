import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/student_session/student_session_detail/bloc/student_session_detail_bloc.dart';

import '../../../../../resources/images.dart';
import '../../../../../themes/colors.dart';
import '../../../../teacher/bookings/model/session_detail_arguments.dart';
import '../../../../teacher/home/model/session_request_model.dart';
import '../../my_session/model/session_detail_response_model.dart';

class RaiseIssueScreen extends StatefulWidget {
  final SessionDetailArguments sessionDetailArguments;
  RaiseIssueScreen({Key? key, required this.sessionDetailArguments})
      : super(key: key);

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  final _issueController = TextEditingController();
  bool isLoading = false;
  bool showError = false;
  SessionDetailResponseModel? sessionDetailResponseModel;

  List<String> reasons = [
    "Couldn't connect call",
    "Network issue",
    "Very low sound",
    "Session was not helpful"
  ];

  List<String> selectedReason = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StudentSessionDetailBloc>(context).add(
        FetchStudentSessionDetailEvent(
            sessionId: widget.sessionDetailArguments.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSessionDetailBloc, StudentSessionDetailStates>(
      listener: (context, state) {
        if (state is RaisedSessionIssueState) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: AppColors.appYellow,
              content: AppText(
                "Issue Raised",
                color: AppColors.whiteColor,
              ),
            ),
          );
        }
        if (state is RaisingSessionIssueFailureState) {
          SnackBar(
            backgroundColor: AppColors.appYellow,
            content: AppText(
              state.msg.toString(),
              color: AppColors.whiteColor,
            ),
          );
        }
        if (state is FetchedStudentSessionDetailState) {
          sessionDetailResponseModel = state.sessionDetailResponseModel;
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 13),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child:
                                  const AppImage(image: ImageAsset.arrowBack)),
                          const SizedBox(
                            height: 40,
                          ),
                          const Center(
                            child: AppImage(
                              image: ImageAsset.chatBot,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                              child: AppText(
                            "Raise an issue",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(child: getReasonListLayout()),
                          const SizedBox(
                            height: 20,
                          ),
                          getOtherIssueEditContainer(),
                          SizedBox(
                            height: 20,
                          ),
                          showError
                              ? AppText(
                                  "select at least one or mention other issue.",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.redColorShadow400,
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                )),
                getBottomView()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getOtherIssueEditContainer() {
    return AppTextFormField(
      hintText: "mention your other issue...",
      maxLines: 10,
      controller: _issueController,
      hintTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget getReasonListLayout() {
    return Wrap(
      runSpacing: 15,
      spacing: 20,
      children: List.generate(reasons.length, (index) => getReasonView(index)),
    );
  }

  onReasonSelected(int index) {
    if (selectedReason.contains(reasons[index])) {
      selectedReason.remove(reasons[index]);
    } else {
      selectedReason.add(reasons[index]);
    }
    setState(() {});
  }

  Widget getReasonView(int index) {
    return GestureDetector(
      onTap: () => onReasonSelected(index),
      child: Container(
        decoration: BoxDecoration(
            color: selectedReason.contains(reasons[index])
                ? AppColors.primaryColor
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.grey35)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                reasons[index],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCancelCTA() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.cyanBlue)),
        child: const Center(
            child: AppText(
          "Cancel",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        )),
      ),
    );
  }

  bool isFormValid() {
    return selectedReason.isNotEmpty || _issueController.text.isNotEmpty;
  }

  onRaiseTicketTap() {
    if (isFormValid()) {
      if (_issueController.text.isNotEmpty) {
        selectedReason.add(_issueController.text);
      }
      isLoading = true;
      BlocProvider.of<StudentSessionDetailBloc>(context).add(
          RaiseIssueForSessionEvent(
              sessionSaveRequest: SessionSaveRequest(
                  id: sessionDetailResponseModel?.id,
                  teacherId: sessionDetailResponseModel?.teacherId,
                  studentId: sessionDetailResponseModel?.studentId,
                  issueRaised: selectedReason)));
    } else {
      isLoading = false;
      showError = true;
      setState(() {});
    }
  }

  Widget getRaiseTicketCTA() {
    return GestureDetector(
      onTap: () => onRaiseTicketTap(),
      child: Container(
        height: 50,
        width: 162,
        decoration: BoxDecoration(
            color: AppColors.cyanBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.cyanBlue)),
        child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  )
                : const AppText(
                    "Raise Ticket",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  )),
      ),
    );
  }

  Widget getBottomView() {
    return Container(
      height: 82,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey, //New
              blurRadius: 5.0,
              offset: Offset(0, -2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(child: getCancelCTA()),
            const SizedBox(
              width: 20,
            ),
            Expanded(child: getRaiseTicketCTA())
          ],
        ),
      ),
    );
  }
}
