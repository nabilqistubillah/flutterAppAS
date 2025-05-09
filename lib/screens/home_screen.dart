import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _transactions = [];

  double get _totalBalance {
    double total = 0.0;
    for (var tx in _transactions) {
      total += tx.isIncome ? tx.amount : -tx.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display total balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.teal[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Saldo:', style: TextStyle(fontSize: 18)),
                Text(
                  'Rp ${_totalBalance.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // List of transactions
          Expanded(
            child: _transactions.isEmpty
                ? const Center(
              child: Text('Belum ada transaksi'),
            )
                : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (ctx, index) {
                final tx = _transactions[index];
                return ListTile(
                  leading: Icon(
                    tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: tx.isIncome ? Colors.green : Colors.red,
                  ),
                  title: Text(tx.title),
                  subtitle: Text(
                    '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                  ),
                  trailing: Text(
                    'Rp ${tx.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: tx.isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Add transaction button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return TransactionForm(
                onSubmit: (title, amount, isIncome) {
                  setState(() {
                    _transactions.add(
                      Transaction(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: title,
                        amount: amount,
                        date: DateTime.now(),
                        isIncome: isIncome,
                      ),
                    );
                  });
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
