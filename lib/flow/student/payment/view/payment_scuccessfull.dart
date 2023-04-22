import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../../../../navigation/app_routes.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  const PaymentSuccessfulScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessfulScreen> createState() =>
      _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
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
                    image: ImageAsset.paymentSuccessful,
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: const AppText(
                    AppStrings.paymentSuccessfulHeader,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                )),
                const SizedBox(
                  height: 14,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: const AppText(
                      AppStrings.paymentSuccessfulInstruction,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey55,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )),
            getGoToHomeCTA(),
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
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.initialRoute, (route) => false);
  }
}
