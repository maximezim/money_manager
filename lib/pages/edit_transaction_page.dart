import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../repositories/account_repository.dart';

class EditTransactionPage extends StatefulWidget {
  final TransactionModel transaction;
  final int index;

  const EditTransactionPage(
      {super.key, required this.transaction, required this.index});

  @override
  EditTransactionPageState createState() => EditTransactionPageState();
}

class EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late DateTime _selectedDate;
  late double _amount;
  Category? _selectedCategory;
  Account? _selectedAccount;
  late String _description;

  final List<String> _transactionTypes = ['Income', 'Spending', 'Transfer'];

  @override
  void initState() {
    super.initState();
    // Pre-populate fields from the transaction passed in.
    _type = widget.transaction.type;
    _selectedDate = widget.transaction.date;
    _amount = widget.transaction.amount;
    _description = widget.transaction.description;

    // Find the matching category/account in the repositories (or fallback to first).
    _selectedCategory = CategoryRepository.categories.firstWhere(
      (cat) => cat.name == widget.transaction.category,
      orElse: () => CategoryRepository.categories.first,
    );
    _selectedAccount = AccountRepository.accounts.firstWhere(
      (acc) => acc.name == widget.transaction.account,
      orElse: () => AccountRepository.accounts.first,
    );
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _selectedAccount != null) {
      _formKey.currentState!.save();
      TransactionModel updated = TransactionModel(
        type: _type,
        date: _selectedDate,
        amount: _amount,
        category: _selectedCategory!.name,
        account: _selectedAccount!.name,
        description: _description,
      );
      await TransactionRepository.updateTransaction(widget.index, updated);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (context) {
        String newCategory = '';
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            onChanged: (value) {
              newCategory = value;
            },
            decoration: const InputDecoration(hintText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newCategory.isNotEmpty) {
                  CategoryRepository.addCategory(Category(name: newCategory));
                  setState(() {
                    _selectedCategory = CategoryRepository.categories.last;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewAccount() {
    showDialog(
      context: context,
      builder: (context) {
        String newAccount = '';
        return AlertDialog(
          title: const Text('Add Account'),
          content: TextField(
            onChanged: (value) {
              newAccount = value;
            },
            decoration: const InputDecoration(hintText: 'Account Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newAccount.isNotEmpty) {
                  AccountRepository.addAccount(Account(name: newAccount));
                  setState(() {
                    _selectedAccount = AccountRepository.accounts.last;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // No title as requested.
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: _transactionTypes
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _type = value;
                    });
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter amount';
                  if (double.tryParse(val) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onSaved: (val) => _amount = double.parse(val!),
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: CategoryRepository.categories
                          .map((cat) => DropdownMenuItem(
                                child: Text(cat.name),
                                value: cat,
                              ))
                          .toList(),
                      onChanged: (Category? value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addNewCategory,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Account>(
                      value: _selectedAccount,
                      decoration: const InputDecoration(labelText: 'Account'),
                      items: AccountRepository.accounts
                          .map((acc) => DropdownMenuItem(
                                child: Text(acc.name),
                                value: acc,
                              ))
                          .toList(),
                      onChanged: (Account? value) {
                        setState(() {
                          _selectedAccount = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addNewAccount,
                  ),
                ],
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => _description = val ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
