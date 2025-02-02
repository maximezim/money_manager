import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static final List<TransactionModel> _transactions = [];
  static final ValueNotifier<List<TransactionModel>> transactionsNotifier =
      ValueNotifier([]);

  /// Loads the saved transactions from local storage.
  static Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('transactions');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      _transactions.clear();
      _transactions.addAll(
        jsonList.map((e) => TransactionModel.fromJson(e)).toList(),
      );
      transactionsNotifier.value = List.from(_transactions);
    }
  }

  /// Saves the current transactions list to local storage.
  static Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String data =
        jsonEncode(_transactions.map((e) => e.toJson()).toList());
    await prefs.setString('transactions', data);
  }

  static List<TransactionModel> getTransactions() => _transactions;

  static Future<void> addTransaction(TransactionModel transaction) async {
    _transactions.add(transaction);
    transactionsNotifier.value = List.from(_transactions);
    await saveTransactions();
  }

  static Future<void> updateTransaction(
      int index, TransactionModel transaction) async {
    if (index >= 0 && index < _transactions.length) {
      _transactions[index] = transaction;
      transactionsNotifier.value = List.from(_transactions);
      await saveTransactions();
    }
  }

  static Future<void> deleteTransaction(int index) async {
    if (index >= 0 && index < _transactions.length) {
      _transactions.removeAt(index);
      transactionsNotifier.value = List.from(_transactions);
      await saveTransactions();
    }
  }
}
