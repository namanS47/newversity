import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/profile_drawer/bloc/profile_drawer_bloc.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';

import '../../../config/app_config.dart';

class ProfileDrawerScreen extends StatefulWidget {
  const ProfileDrawerScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDrawerScreen> createState() => _ProfileDrawerScreenState();
}

class _ProfileDrawerScreenState extends State<ProfileDrawerScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileDrawerBloc, ProfileDrawerStates>(
      listener: (context, state) {
        if (state is LoggedOutState) {
          isLoading = false;
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.loginRoute, (route) => false);
        }
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
                      itemCount: context
                          .read<ProfileDrawerBloc>()
                          .drawerOptions
                          .length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 26),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => getDrawerScreen(index),
                          child: Row(
                            children: [
                              AppImage(
                                image: context
                                    .read<ProfileDrawerBloc>()
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
              GestureDetector(
                onTap: () => onLogout(),
                child: Container(
                  height: 71,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            )
                          : const AppText(
                              "LOGOUT",
                              color: AppColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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

  onLogout() {
    isLoading = true;
    BlocProvider.of<ProfileDrawerBloc>(context).add(LogoutEvent());
  }

  String getDrawerOptionTitle(BuildContext context, int index) {
    switch (index) {
      case 0:
        return AppStrings.bank;
      case 1:
        return AppStrings.privacyPolicy;
      case 2:
        return AppStrings.termsAndCondition;
      case 3:
        return AppStrings.helpAndSupport;
      case 4:
        return AppStrings.faqs;
      default:
        return '';
    }
  }

  void getDrawerScreen(int index) {
    switch (index) {
      // case 0:
      //   Navigator.of(context).pushNamed(AppRoutes.share);
      //   break;
      case 0:
        Navigator.of(context).pushNamed(AppRoutes.addBankAccount);
        break;
      // case 2:
      //   Navigator.of(context).pushNamed(AppRoutes.settings);
      //   break;
      case 1:
        Navigator.of(context).pushNamed(AppRoutes.webViewRoute, arguments: AppConfig.instance.config.privacyPolicyUrl);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoutes.webViewRoute, arguments: AppConfig.instance.config.termsAndConditionsUrl);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoutes.helpAndSupport);
        return;
      case 4:
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
