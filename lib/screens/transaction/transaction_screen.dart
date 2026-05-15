import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/transaction_model.dart';
import '../../providers/transaction_provider.dart';

class TransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  final int? index;

  const TransactionScreen({super.key, this.transaction, this.index});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      titleController.text = widget.transaction!.title;
      amountController.text = widget.transaction!.amount.toString();
      categoryController.text = widget.transaction!.category;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void save() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim());
    final category = categoryController.text.trim();

    if (title.isEmpty || amount == null || category.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final transaction = TransactionModel(
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now(),
    );

    final provider = Provider.of<TransactionProvider>(context, listen: false);

    if (widget.transaction == null) {
      provider.addTransaction(transaction);
    } else {
      provider.updateTransaction(widget.index!, transaction);
    }

    Navigator.pop(context);
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              // 💳 Form Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: inputStyle('Title', Icons.title),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: inputStyle('Amount', Icons.attach_money),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: categoryController,
                      decoration: inputStyle('Category', Icons.category),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🚀 Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.transaction == null
                        ? 'Save Transaction'
                        : 'Update Transaction',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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
