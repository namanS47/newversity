import 'package:flutter/material.dart';
import 'package:newversity/navigation/app_routes.dart';

import '../../../../common/common_widgets.dart';
import '../../../../resources/images.dart';
import '../../../../themes/colors.dart';
import '../../../../themes/strings.dart';

class PaymentFailureScreen extends StatefulWidget {
  const PaymentFailureScreen({Key? key}) : super(key: key);

  @override
  State<PaymentFailureScreen> createState() => _PaymentFailureScreenState();
}

class _PaymentFailureScreenState extends State<PaymentFailureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: AppImage(
                    image: ImageAsset.paymentError,
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                const Center(
                    child: AppText(
                  AppStrings.paymentErrorHeader,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                )),
                const SizedBox(
                  height: 14,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 150,
                    child: const AppText(
                      AppStrings.paymentErrorInstruction,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey55,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )),
            getGoToHomeCTA()
          ],
        ),
      ),
    );
  }

  Widget getGoToHomeCTA() {
    return AppCta(
      text: "Go to home",
      onTap: () => goToHome(),
    );
  }

  goToHome() {
    Navigator.pop(context);
    Navigator.pop(context);
    // Navigator.popUntil(context, ModalRoute.withName(AppRoutes.teacherHomePageRoute));
  }
}
