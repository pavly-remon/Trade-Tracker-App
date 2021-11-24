part of 'account_cubit.dart';

abstract class AccountState {
  List<Account> accounts = AccountRepository.accounts;
}

class AccountInitial extends AccountState {}

class AddAccount extends AccountState {
  final Account account;
  AddAccount({required this.account}) {
    AccountRepository.insertAccount(account);
  }
}

class DelAccount extends AccountState {
  final String accountId;
  DelAccount({required this.accountId}) {
    AccountRepository.deleteAccount(accountId);
  }
}
