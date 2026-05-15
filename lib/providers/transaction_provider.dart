import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final Box<TransactionModel> transactionBox = Hive.box<TransactionModel>(
    'transactions',
  );

  List<TransactionModel> get transactions => transactionBox.values.toList();

  List<dynamic> get keys => transactionBox.keys.toList();

  double get totalExpenses {
    return transactions.fold(0, (sum, item) => sum + item.amount);
  }

  void addTransaction(TransactionModel transaction) {
    transactionBox.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(int index) {
    final key = transactionBox.keyAt(index);
    transactionBox.delete(key);
    notifyListeners();
  }

  void updateTransaction(int index, TransactionModel updatedTransaction) {
    final key = transactionBox.keyAt(index);
    transactionBox.put(key, updatedTransaction);
    notifyListeners();
  }

  void clearAll() {
    transactionBox.clear();
    notifyListeners();
  }
}
