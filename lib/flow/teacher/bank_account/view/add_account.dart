import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/bank_account/bloc/bank_account_bloc.dart';
import 'package:newversity/flow/teacher/bank_account/model/bank_request_model.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({Key? key}) : super(key: key);

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  bool isLoading = false;
  bool isShowError = false;

  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _reEnterAccountNumberController =
      TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _accountHolderNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: BlocConsumer<BankAccountBloc, BankAccountStates>(
        listener: (context, state) {
          if (state is AddedBankAccountState) {
            isLoading = false;
            Navigator.pop(context);
          }else if(state is AddingBankAccountFailureState){
            print(" see the error ${state.msg}");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding:  const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () => {Navigator.pop(context)},
                          child: const AppImage(image: ImageAsset.arrowBack)),
                      const SizedBox(
                        width: 10,
                      ),
                      const AppText(
                        "Add bank account",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          getHeaderText("Account Number"),
                          const SizedBox(
                            width: 10,
                          ),
                          getCompulsuryWidget()
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextFormField(
                        hintText: "Enter account number",
                        controller: _accountNumberController,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          getHeaderText("Re-enter Account Number"),
                          const SizedBox(
                            width: 10,
                          ),
                          getCompulsuryWidget(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextFormField(
                        hintText: "Enter Re-enter account number",
                        controller: _reEnterAccountNumberController,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          getHeaderText("IFSC Code"),
                          const SizedBox(
                            width: 10,
                          ),
                          getCompulsuryWidget(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextFormField(
                        hintText: "Enter IFSC code",
                        controller: _ifscCodeController,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      getHeaderText("Account Holder Name"),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextFormField(
                        hintText: "Enter account holder name",
                        controller: _accountHolderNameController,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      getErrorWidget()
                    ],
                  )),
                  AppCta(
                    text: "Add",
                    isLoading: isLoading,
                    onTap: () => onAddingAccountTap(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getErrorWidget() {
    return Visibility(
      visible: isShowError,
      child: const AppText(
        "Please fill all the compulsary details.",
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.redColorShadow400,
      ),
    );
  }

  Widget getCompulsuryWidget() {
    return const Icon(
      Icons.star_purple500_outlined,
      size: 10,
      color: AppColors.redColorShadow400,
    );
  }

  Widget getHeaderText(String header) {
    return AppText(
      header,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  bool isFormValid() {
    return _accountNumberController.text.isNotEmpty &&
        _reEnterAccountNumberController.text.isNotEmpty &&
        _ifscCodeController.text.isNotEmpty;
  }


  onAddingAccountTap() {
    if (isFormValid()) {
      isLoading = true;
      BlocProvider.of<BankAccountBloc>(context).add(
        AddBankAccountEvent(
          addBankRequestModel: AddBankRequestModel(
              teacherId: CommonUtils().getLoggedInUser(),
              accountNumber: _accountNumberController.text,
              accountName: _accountHolderNameController.text,
              ifscCode: _ifscCodeController.text),
        ),
      );
    } else {
      isShowError = true;
      setState(() {});
    }
  }
}
