part of 'bank_account_bloc.dart';

abstract class BankAccountStates {}

class BankAccountInitialState extends BankAccountStates {}

class FetchingBankDetailsState extends BankAccountStates {}

class FetchedBankDetailsState extends BankAccountStates {
  final BankResponseModel? bankResponseModel;
  FetchedBankDetailsState({required this.bankResponseModel});
}

class FetchingBankDetailsFailureState extends BankAccountStates {
  final String msg;
  FetchingBankDetailsFailureState({required this.msg});
}

class AddingBankAccountState extends BankAccountStates {}

class AddedBankAccountState extends BankAccountStates {}

class AddingBankAccountFailureState extends BankAccountStates {
  String msg;
  AddingBankAccountFailureState({required this.msg});
}
