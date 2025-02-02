import 'package:flutter/material.dart';
import 'transactions_page.dart';
import 'statistics_page.dart';
import 'account_page.dart';
import 'settings_page.dart';
import 'add_transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    TransactionsPage(),
    StatisticsPage(),
    AccountPage(),
    SettingsPage(),
  ];

  void _onAddTransaction() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddTransactionPage()))
        .then((_) {
      // When returning from the add page, rebuild if needed.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 40,
      // ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTransaction,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.list), label: 'Transactions'),
          NavigationDestination(
              icon: Icon(Icons.show_chart), label: 'Statistics'),
          NavigationDestination(
              icon: Icon(Icons.account_balance_wallet), label: 'Account'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
