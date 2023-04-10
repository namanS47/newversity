part of 'bank_account_bloc.dart';

@immutable
abstract class BankAccountEvents {}

class AddBankAccountEvent extends BankAccountEvents {
  final addBankRequestModel;
  AddBankAccountEvent({required this.addBankRequestModel});
}

class FetchBankDetailsEvent extends BankAccountEvents {}
