import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../repositories/account_repository.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  AddTransactionPageState createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Income';
  DateTime _selectedDate = DateTime.now();
  double _amount = 0.0;
  Category? _selectedCategory;
  Account? _selectedAccount;
  String _description = '';

  final List<String> _transactionTypes = ['Income', 'Spending', 'Transfer'];

  @override
  void initState() {
    super.initState();
    if (CategoryRepository.categories.isNotEmpty) {
      _selectedCategory = CategoryRepository.categories.first;
    }
    if (AccountRepository.accounts.isNotEmpty) {
      _selectedAccount = AccountRepository.accounts.first;
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _selectedAccount != null) {
      _formKey.currentState!.save();
      TransactionModel transaction = TransactionModel(
        type: _type,
        date: _selectedDate,
        amount: _amount,
        category: _selectedCategory!.name,
        account: _selectedAccount!.name,
        description: _description,
      );
      await TransactionRepository.addTransaction(transaction);
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
            decoration: const InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            FilledButton(
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
            decoration: const InputDecoration(
              labelText: 'Account Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            FilledButton(
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: _transactionTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _type = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                title: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter amount';
                  if (double.tryParse(val) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (val) => _amount = double.parse(val!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: CategoryRepository.categories
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat.name),
                              ))
                          .toList(),
                      onChanged: (Category? value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: _addNewCategory,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Account>(
                      value: _selectedAccount,
                      decoration: const InputDecoration(
                        labelText: 'Account',
                        border: OutlineInputBorder(),
                      ),
                      items: AccountRepository.accounts
                          .map((acc) => DropdownMenuItem(
                                value: acc,
                                child: Text(acc.name),
                              ))
                          .toList(),
                      onChanged: (Account? value) {
                        setState(() {
                          _selectedAccount = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: _addNewAccount,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => _description = val ?? '',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saveTransaction,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
