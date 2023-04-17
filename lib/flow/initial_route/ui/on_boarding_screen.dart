import 'package:flutter/material.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const AppImage(
              image: ImageAsset.icOnBoarding,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: Column(
                children: const [
                  SizedBox(
                    height: 150,
                  ),
                  Center(
                    child: AppText(
                      "Welcome to",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: AppImage(image: ImageAsset.icNewVersityLogo),
                  )
                ],
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    AppText(
                      "Empowering students to reach their full potential through mentorship.",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 37,
                    ),
                    AppCta(
                      color: AppColors.whiteColor,
                      text: "Get Started",
                      textColor: AppColors.blackMerlin,
                    ),
                    SizedBox(
                      height: 57,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
