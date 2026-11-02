import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/currency_viewmodel.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  late String _tempCurrency;

  @override
  void initState() {
    super.initState();
    _tempCurrency = ref.read(currencyViewModelProvider).value ?? 'VND';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Đơn vị tiền tệ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCurrencyOption(
            label: 'VND (Việt Nam đồng)',
            value: 'VND',
          ),
          const SizedBox(height: 6),
          _buildCurrencyOption(
            label: 'USD (Đô la Mỹ)',
            value: 'USD',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            ref
                .read(currencyViewModelProvider.notifier)
                .setCurrency(_tempCurrency);
            Navigator.of(context).pop();
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }

  Widget _buildCurrencyOption({
    required String label,
    required String value,
  }) {
    final isSelected = _tempCurrency == value;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.black12 : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        leading: isSelected
            ? const Icon(Icons.check_circle, color: Colors.black)
            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.black87,
            fontSize: 15,
          ),
        ),
        onTap: () {
          setState(() {
            _tempCurrency = value;
          });
        },
      ),
    );
  }
}
