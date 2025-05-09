import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Function(String, double, bool) onSubmit;

  const TransactionForm({super.key, required this.onSubmit});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = true;

  void _submitData() {
    final enteredTitle = _titleController.text.trim();
    final enteredAmount = double.tryParse(_amountController.text) ?? 0;

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.onSubmit(enteredTitle, enteredAmount, _isIncome);
    Navigator.of(context).pop(); // Tutup modal
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Judul'),
              controller: _titleController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Jenis:'),
                const SizedBox(width: 10),
                DropdownButton<bool>(
                  value: _isIncome,
                  items: const [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Pemasukan'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('Pengeluaran'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _isIncome = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Tambah Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
