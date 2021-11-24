import 'package:bloc/bloc.dart';
import 'package:resolution_app/models/account.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());
  void add(Account account) => emit(AddAccount(account: account));
  void remove(String id) => emit(DelAccount(accountId: id));
}
