import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/account.dart';

class AccountRepository {
  static final List<Account> accounts = [
    Account(name: 'Cash'),
    Account(name: 'Bank'),
    Account(name: 'Credit Card'),
  ];

  static Future<void> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('accounts');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      accounts.clear();
      accounts.addAll(jsonList.map((e) => Account.fromJson(e)).toList());
    }
  }

  static Future<void> saveAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(accounts.map((e) => e.toJson()).toList());
    await prefs.setString('accounts', data);
  }

  static Future<void> addAccount(Account account) async {
    accounts.add(account);
    await saveAccounts();
  }
}
