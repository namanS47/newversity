import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({Key? key}) : super(key: key);

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: AppImage(
              image: ImageAsset.paymentProcessing,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const AppText(
            "Payment Processing...",
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 14,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: const AppText(
                "This might take up-to a minute .Please do not close the app.",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey55,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
