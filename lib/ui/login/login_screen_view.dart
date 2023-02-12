import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:newversity/controllers/login_controller.dart';
import 'package:newversity/utils/new_versity_color_constant.dart';
import 'package:newversity/utils/new_versity_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../generated/l10n.dart';
import '../../utils/new_versity_error_text.dart';
import '../../utils/new_versity_text_form_field.dart';

class PhoneNumberView extends StatelessWidget {
  final loginController = Get.find<LoginController>();

  PhoneNumberView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundedTextFormField(
          height: 42,
          isNumber: true,
          controller: loginController.phoneController,
          hintText: S.of(context).mobileDescription,
          keyboardType: TextInputType.phone,
        ),
        if (loginController.errorPhoneText.isNotEmpty)
          ErrorText(errorText: loginController.errorPhoneText.value),
      ],
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterDemoText(
      S.of(context).hello,
      fontSize: 30.px,
      fontWeight: FontWeight.w400,
    );
  }
}

class LoginDescriptionText extends StatelessWidget {
  const LoginDescriptionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterDemoText(
      S.of(context).descriptionText,
      fontSize: 12.px,
      fontWeight: FontWeight.w500,
      color: FlutterDemoColorConstant.appLightBlack,
    );
  }
}
