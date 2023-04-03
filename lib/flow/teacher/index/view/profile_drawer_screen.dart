import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../bloc/index_bloc.dart';

class ProfileDrawerScreen extends StatefulWidget {
  const ProfileDrawerScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDrawerScreen> createState() => _ProfileDrawerScreenState();
}

class _ProfileDrawerScreenState extends State<ProfileDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IndexBloc, IndexState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(color: AppColors.whiteColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    InkWell(
                        onTap: () => {Navigator.pop(context)},
                        child: const AppImage(image: ImageAsset.close)),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  primary: true,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: context.read<IndexBloc>().drawerOptions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 26),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => getDrawerScreen(index),
                          child: Row(
                            children: [
                              AppImage(
                                image: context
                                    .read<IndexBloc>()
                                    .drawerOptions[index],
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 18),
                              AppText(
                                getDrawerOptionTitle(context, index),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              Container(
                height: 71,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: AppText(
                      "LOGOUT",
                      color: AppColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String getDrawerOptionTitle(BuildContext context, int index) {
    switch (index) {
      case 0:
        return AppStrings.share;
      case 1:
        return AppStrings.bank;
      case 2:
        return AppStrings.settings;
      case 3:
        return AppStrings.privacyPolicy;
      case 4:
        return AppStrings.termsAndCondition;
      case 5:
        return AppStrings.helpAndSupport;
      case 6:
        return AppStrings.faqs;
      default:
        return '';
    }
  }

  void getDrawerScreen(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(AppRoutes.share);
        break;
      case 1:
        Navigator.of(context).pushNamed(AppRoutes.bank);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoutes.settings);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoutes.privacyPolicy);
        break;
      case 4:
        Navigator.of(context).pushNamed(AppRoutes.termsAndCondition);
        break;
      case 5:
        Navigator.of(context).pushNamed(AppRoutes.helpAndSupport);
        return;
      case 6:
        Navigator.of(context).pushNamed(AppRoutes.faqs);
        return;
      case 7:
        return;
      case 8:
        return;
      default:
        return;
    }
  }
}
