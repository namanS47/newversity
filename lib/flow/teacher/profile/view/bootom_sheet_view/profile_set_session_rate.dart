import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

class ProfileEditSessionRate extends StatefulWidget {
  const ProfileEditSessionRate({Key? key}) : super(key: key);

  @override
  State<ProfileEditSessionRate> createState() => _ProfileEditSessionRateState();
}

class _ProfileEditSessionRateState extends State<ProfileEditSessionRate> {
  var session15minController = TextEditingController();
  var session30minController = TextEditingController();
  List<String> listOfSession = ["For 15 min session", "For 30 min session"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                "Set your fee",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 20,
              ),
              getListOfSessionLayout(),
              const SizedBox(
                height: 20,
              ),
              getUpdateCTA(),
            ],
          ),
        ),
      ),
    );
  }

  onSessionRateUpdate() {
    print("This is 15 min rate${session15minController.text}");
    print("This is 30 min rate${session30minController.text}");
  }

  Widget getUpdateCTA() {
    return AppCta(
      text: AppStrings.update,
      isLoading: false,
      onTap: () => onSessionRateUpdate(),
    );
  }

  Widget getListOfSessionLayout() {
    return Wrap(
      spacing: 30,
      runSpacing: 12,
      children: List.generate(
        listOfSession.length,
        (curIndex) {
          return sessionEditView(curIndex);
        },
      ),
    );
  }

  Widget sessionEditView(int index) {
    return Row(
      children: [
        Expanded(
            child: AppText(
          listOfSession[index],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        )),
        Container(
          width: 144,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.grey32.withOpacity(0.45),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: TextFormField(
                controller: index == 0
                    ? session15minController
                    : session30minController,
                decoration: InputDecoration(
                    hintText: index == 0 ? "₹150" : "₹250",
                    hintStyle: const TextStyle(
                        fontSize: 16,
                        color: AppColors.blackMerlin,
                        fontWeight: FontWeight.w500),
                    border: InputBorder.none),
              ),
            ),
          ),
        )
      ],
    );
  }
}
