import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../viewmodels/currency_viewmodel.dart';
import '../viewmodels/expense_viewmodel.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late String _selectedCategory;

  final List<String> _categories = [
    'Sinh hoạt',
    'Đi lại',
    'Học tập',
    'Sức khỏe',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.name);
    _dateController = TextEditingController(text: widget.expense.date);

    final currentCurrency = ref.read(currencyViewModelProvider).value ?? 'VND';
    final currencyNotifier = ref.read(currencyViewModelProvider.notifier);
    final displayCost = currencyNotifier.convertFromVnd(widget.expense.cost, currentCurrency);

    final amountText = displayCost % 1 == 0
        ? displayCost.toInt().toString()
        : displayCost.toStringAsFixed(2);
    _amountController = TextEditingController(text: amountText);

    if (_categories.contains(widget.expense.type)) {
      _selectedCategory = widget.expense.type;
    } else {
      _selectedCategory = _categories.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final currentCurrency = ref.read(currencyViewModelProvider).value ?? 'VND';
      final currencyNotifier = ref.read(currencyViewModelProvider.notifier);

      final updatedTitle = _titleController.text.trim();
      final enteredAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final updatedDate = _dateController.text.trim();

      final costInVnd = currencyNotifier.convertToVnd(enteredAmount, currentCurrency);

      final updatedExpense = widget.expense.copyWith(
        name: updatedTitle,
        cost: costInVnd,
        type: _selectedCategory,
        date: updatedDate,
      );

      ref.read(expenseListViewModelProvider.notifier).updateExpense(updatedExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật thông tin khoản chi!')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCurrency = ref.watch(currencyViewModelProvider).value ?? 'VND';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa khoản chi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Tên khoản chi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên khoản chi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Số tiền ($currentCurrency)',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Số tiền phải là chữ số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Ngày chi tiêu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập ngày chi tiêu';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
