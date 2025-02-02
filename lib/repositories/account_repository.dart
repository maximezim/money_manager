import '../models/account.dart';

class AccountRepository {
  static final List<Account> accounts = [
    Account(name: 'Cash'),
    Account(name: 'Bank'),
    Account(name: 'Credit Card'),
  ];

  static void addAccount(Account account) {
    accounts.add(account);
  }
}
