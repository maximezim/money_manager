import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/pages/home_page.dart';
import 'repositories/transaction_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide the system bottom navigation bar and keep only the status bar.
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  // Make the status bar transparent.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await TransactionRepository.loadTransactions();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Finance Tracker",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
