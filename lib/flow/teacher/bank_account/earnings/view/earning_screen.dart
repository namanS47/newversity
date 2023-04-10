import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/bank_account/bloc/bank_account_bloc.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_response_model.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/strings.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../../../../../common/common_widgets.dart';
import '../../../../../themes/colors.dart';
import '../model/earning_details.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({Key? key}) : super(key: key);

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BankAccountBloc>(context).add(FetchBankDetailsEvent());
  }

  bool isBankAdded = true;
  List<EarningDetails> listOfEarningDetails = EarningDetails.earningDetails;
  BankResponseModel? bankResponseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: const AppImage(image: ImageAsset.arrowBack)),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    getBankDetailsContainer(),
                    const SizedBox(
                      height: 20,
                    ),
                    const AppText(
                      "Earning History",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getEarningHistoryList(),
                    getZeroEarningView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getZeroEarningView() {
    return Visibility(
      visible: !isBankAdded || listOfEarningDetails.isEmpty,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AppImage(image: ImageAsset.zeroEarnings),
              SizedBox(
                height: 40,
              ),
              AppText(
                AppStrings.zeroEarnings,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getEarningHistoryList() {
    return Visibility(
      visible: isBankAdded,
      child: Wrap(
        spacing: 30,
        runSpacing: 12,
        children: List.generate(
          listOfEarningDetails.length,
          (curIndex) {
            return getEarningDetailsView(curIndex);
          },
        ),
      ),
    );
  }

  Widget getEarningDetailsView(int index) {
    return Row(
      children: [
        getProfileImage(index),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    listOfEarningDetails[index].studentName ?? "",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  AppText(
                    "₹ ${listOfEarningDetails[index].rupeesPaid ?? 0}",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    listOfEarningDetails[index].sessionType ?? "",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  AppText(
                    "On: ${DateTimeUtils.getBirthFormattedDateTime(listOfEarningDetails[index].transactionDate ?? DateTime.now())}",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getProfileImage(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        height: 48,
        width: 48,
        child: CircleAvatar(
          radius: 30.0,
          foregroundImage: listOfEarningDetails[index].profileImageUrl != null
              ? NetworkImage(listOfEarningDetails[index].profileImageUrl ?? "")
              : null,
          child: listOfEarningDetails[index].profileImageUrl == null
              ? const AppImage(
                  image: ImageAsset.blueAvatar,
                )
              : CommonWidgets.getCircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getBankDetailsContainer() {
    return BlocConsumer<BankAccountBloc, BankAccountStates>(
      listener: (context, state) {
        if (state is FetchedBankDetailsState &&
            state.bankResponseModel != null) {
          bankResponseModel = state.bankResponseModel;
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.perSessionRate,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const AppText(
                    "Total",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AppText(
                        "Earnings",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      AppText(
                        "₹00",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  getBankDetailsView(),
                  getBankAccountAddCTA(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getBankDetailsView() {
    return Visibility(
      visible: bankResponseModel != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppText(
            "Bank",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: 5,
          ),
          AppText(
            "XXXX XXXX XXXX XXXX",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }

  onTapOnAccountAddCTA() async {
    await Navigator.of(context).pushNamed(AppRoutes.addBankAccount);
    BlocProvider.of<BankAccountBloc>(context).add(FetchBankDetailsEvent());
  }

  Widget getBankAccountAddCTA() {
    return Visibility(
      visible: bankResponseModel == null,
      child: AppCta(
        onTap: () => onTapOnAccountAddCTA(),
        color: AppColors.whiteColor,
        textColor: AppColors.blackMerlin,
        text: "Add bank account",
      ),
    );
  }
}
