import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../viewmodels/currency_viewmodel.dart';
import '../viewmodels/expense_viewmodel.dart';
import 'edit_expense_screen.dart';
import 'settings_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _formatAmount(double amount, String currency) {
    if (currency == 'USD') {
      return amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(2);
    }
    return amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListViewModelProvider);
    final currencyAsync = ref.watch(currencyViewModelProvider);

    final currency = currencyAsync.value ?? 'VND';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Đơn vị tiền tệ',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
          ),
        ],
      ),
      body: expensesAsync.when(
        data: (expenses) {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return _buildExpenseItem(context, ref, expense, currency);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Đã có lỗi xảy ra: $err')),
      ),
    );
  }

  Widget _buildExpenseItem(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
    String currency,
  ) {
    final currencyNotifier = ref.read(currencyViewModelProvider.notifier);
    final convertedCost = currencyNotifier.convertFromVnd(expense.cost, currency);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.type,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    expense.date,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatAmount(convertedCost, currency)} $currency',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Chỉnh sửa',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditExpenseScreen(expense: expense),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
