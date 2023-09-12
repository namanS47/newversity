import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/webinar/bloc/webinar_bloc.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../data/model/webinar_details_response_model.dart';

class WebinarTab extends StatefulWidget {
  const WebinarTab({Key? key}) : super(key: key);

  @override
  State<WebinarTab> createState() => _WebinarTabState();
}

class _WebinarTabState extends State<WebinarTab> {
  @override
  void initState() {
    BlocProvider.of<WebinarBloc>(context).add(FetchWebinarListEvent());
    super.initState();
  }

  bool _isRebuildWidgetState(WebinarState state) {
    return state is FetchWebinarListLoadingState ||
        state is FetchWebinarListSuccessState ||
        state is RegisterForWebinarFailureState;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Upcoming webinar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          BlocBuilder<WebinarBloc, WebinarState>(
            builder: (context, state) {
              if (state is FetchWebinarListSuccessState) {
                if (state.webinarList.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "No Webinar",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SvgPicture.asset(ImageAsset.nothingFoundIcon)
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: ListView(
                    children: state.webinarList
                        .map((webinarDetails) =>
                            WebinarCard(webinarDetails: webinarDetails))
                        .toList(),
                  ),
                );
              } else if (state is FetchWebinarListLoadingState) {
                return CommonWidgets.getCircularProgressIndicator();
              } else {
                return Container();
              }
            },
            buildWhen: (previous, current) => _isRebuildWidgetState(current),
          ),
        ],
      ),
    );
  }
}

class WebinarCard extends StatefulWidget {
  final WebinarDetailsResponseModel webinarDetails;

  const WebinarCard({Key? key, required this.webinarDetails}) : super(key: key);

  @override
  State<WebinarCard> createState() => _WebinarCardState();
}

class _WebinarCardState extends State<WebinarCard> {
  String studentId = CommonUtils().getLoggedInUser();
  final TextEditingController _agendaController = TextEditingController();

  @override
  void dispose() {
    _agendaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey32),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              _dateContainer(widget.webinarDetails),
              const Spacer(),
              _registrationContainer(widget.webinarDetails)
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.webinarDetails.title ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColors.cyanBlue,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  _getMentorsProfileImage(),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.webinarDetails.teacherName ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.webinarDetails.teacherTitle ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey38,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _cardBottomWidget()
            ],
          )
        ],
      ),
    );
  }

  Widget _cardBottomWidget() {
    return Row(
      children: [
        BlocBuilder<WebinarBloc, WebinarState>(builder: (context, state) {
          bool alreadyRegistered = false;
          widget.webinarDetails.studentsInfoList?.forEach((element) {
            if (element.studentId == studentId) {
              alreadyRegistered = true;
            }
          });
          if (state is RegisterForWebinarSuccessState &&
              widget.webinarDetails.id == state.webinarId) {
            widget.webinarDetails.studentsInfoList?.add(StudentsInfoList(studentId: CommonUtils().getLoggedInUser()));
            alreadyRegistered = true;
          }
          return AppCta(
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width - 150,
            isLoading: state is RegisterForWebinarLoadingState &&
                widget.webinarDetails.id == state.webinarId,
            onTap: () {
              if (!alreadyRegistered) {
                askForAgenda();
              }
            },
            text: alreadyRegistered ? "Already Registered" : "Register Now",
          );
        }),

        const Spacer(),
        InkWell(
          onTap: () {
            FlutterShare.share(
                title: widget.webinarDetails.title ?? "",
                linkUrl: widget.webinarDetails.shareLink);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cyanBlue.withOpacity(0.2),
              ),
            ),
            child: const Icon(
              Icons.ios_share_outlined,
              color: AppColors.cyanBlue,
            ),
          ),
        )
      ],
    );
  }

  Future<void> askForAgenda() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: getAgendaContainer(),
        );
      },
    );
  }

  Widget getAgendaContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 350,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(width: 0.9, color: AppColors.grey32),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              "Please mention why you want to join this session by ${widget.webinarDetails.teacherName} ",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.0, top: 20),
              child: AppTextFormField(
                autofocus: true,
                hintText: "Agenda",
                keyboardType: TextInputType.text,
                fillColor: AppColors.grey35,
                controller: _agendaController,
                maxLines: 6,
                // decoration: InputDecoration(
                //   border: InputBorder.none,
                // ),
              ),
            ),
            AppCta(
              text: "Submit",
              onTap: () {
                context.read<WebinarBloc>().add(RegisterForWebinarEvent(
                    webinarId: widget.webinarDetails.id!,
                    agenda: _agendaController.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMentorsProfileImage() {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      width: 50,
      child: widget.webinarDetails.teacherProfilePicture == null ||
              widget.webinarDetails.teacherProfilePicture?.contains("https") ==
                  false
          ? const AppImage(
              image: ImageAsset.blueAvatar,
            )
          : CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  widget.webinarDetails.teacherProfilePicture ?? ""),
            ),
    );
  }

  Widget _dateContainer(WebinarDetailsResponseModel webinarDetails) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.peacefulGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SvgPicture.asset(ImageAsset.clockCircle),
          const SizedBox(
            width: 4,
          ),
          if (webinarDetails.webinarDate != null)
            Text(
              DateTimeUtils.getWebinarDateFormat(webinarDetails.webinarDate!),
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.blackMerlin,
                  fontWeight: FontWeight.w500),
            )
        ],
      ),
    );
  }

  Widget _registrationContainer(WebinarDetailsResponseModel webinarDetails) {
    late int registrationCount;
    if (webinarDetails.studentsInfoList?.length != null &&
        webinarDetails.studentsInfoList!.length > 17) {
      registrationCount = webinarDetails.studentsInfoList!.length;
    } else {
      registrationCount = 17;
    }
    return Container(
      decoration: BoxDecoration(
          color: AppColors.searchColor,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(
            Icons.people,
            size: 20,
          ),
          Text(registrationCount.toString())
        ],
      ),
    );
  }
}
