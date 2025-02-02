import 'package:flutter/material.dart';
import '../repositories/transaction_repository.dart';
import '../models/transaction.dart';
import 'edit_transaction_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  TransactionsPageState createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage> {
  // "list" or "calendar"
  String _viewMode = 'list';

  Color _getCircleColor(TransactionModel tx) {
    if (tx.type.toLowerCase() == 'income') {
      return Colors.green.shade200;
    } else if (tx.type.toLowerCase() == 'spending') {
      return Colors.red.shade200;
    } else {
      return Colors.blue.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _viewMode == 'list'
                ? ValueListenableBuilder<List<TransactionModel>>(
                    key: const ValueKey('list'),
                    valueListenable: TransactionRepository.transactionsNotifier,
                    builder: (context, transactions, _) {
                      return ListView.separated(
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 0),
                        itemBuilder: (context, index) {
                          final TransactionModel tx = transactions[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCircleColor(tx),
                              child: Text(
                                tx.category.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            title: Text('${tx.category} - ${tx.type}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${tx.date.toLocal()}'.split(' ')[0]),
                                if (tx.description.isNotEmpty)
                                  Text(
                                    tx.description,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                              ],
                            ),
                            trailing: Text('\$${tx.amount.toStringAsFixed(2)}'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => EditTransactionPage(
                                    transaction: tx, index: index),
                              ));
                            },
                          );
                        },
                      );
                    },
                  )
                : Center(
                    key: const ValueKey('calendar'),
                    child: Text('Calendar view not implemented'),
                  ),
          ),
        ),
        // Segmented button positioned at the bottom
        Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 4.0, bottom: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<String>(
              segments: <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'list',
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 60),
                    child: const Center(child: Text('List')),
                  ),
                ),
                ButtonSegment<String>(
                  value: 'calendar',
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 60),
                    child: const Center(child: Text('Calendar')),
                  ),
                ),
              ],
              selected: <String>{_viewMode},
              style: ButtonStyle(
                foregroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.onPrimaryContainer;
                  }
                  return Theme.of(context).colorScheme.onSurface;
                }),
                backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.primaryContainer;
                  }
                  return Colors.transparent;
                }),
              ),
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _viewMode = newSelection.first;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
