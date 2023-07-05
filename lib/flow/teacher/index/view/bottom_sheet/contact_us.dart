import 'package:flutter/material.dart';
import 'package:newversity/resources/images.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../services/call_message_service.dart';
import '../../../../../services/service_locator.dart';
import '../../../../../themes/colors.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key}) : super(key: key);

  final CallsAndMessagesService _service = getIt<CallsAndMessagesService>();

  final String number = "8949704799";
  final String email = "contact@newversity.in";

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
                "Contact us",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 20,
              ),
              const AppText(
                "We will be ready any time to resolve your queries",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 30,
              ),
              getCallContainer(),
              const SizedBox(
                height: 20,
              ),
              getChatContainer(),
              const SizedBox(
                height: 20,
              ),
              getMailContainer(),
            ],
          ),
        ),
      ),
    );
  }

  onTapOfChat() {
    _service.sendWhatsAppMessage(number);
  }

  onTapOfMail() {
    _service.sendEmail(email);
  }

  Widget getChatContainer() {
    return GestureDetector(
      onTap: () => onTapOfChat(),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Row(
            children: [
              const AppImage(image: ImageAsset.chat),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    "Chat",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AppText(
                    "Live chat on whatsapp",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey50,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getMailContainer() {
    return GestureDetector(
      onTap: () => onTapOfMail(),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Row(
            children: [
              const AppImage(image: ImageAsset.mail),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    "Mail",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AppText(
                    'Response time : Within 24 hours',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey50,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  onTapOfCall() {
    _service.call(number);
  }

  Widget getCallContainer() {
    return GestureDetector(
      onTap: () => onTapOfCall(),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.grey35, borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Row(
            children: [
              const AppImage(image: ImageAsset.call),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    "Call",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AppText(
                    'wait time : 2-5 min',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey50,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
