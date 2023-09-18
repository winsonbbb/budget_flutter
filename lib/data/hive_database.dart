import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:budget_flutter/model/expense_item.dart';

class HiveDataBase {
  final _myBox = Hive.box("expense_database");

  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];

    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }

    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  List<ExpenseItem> readData() {
    List<ExpenseItem> allExpense = [];
    if(_myBox.get("ALL_EXPENSES")==null){
      return allExpense;
    }
    List savedExpenses = _myBox.get("ALL_EXPENSES");

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];
      ExpenseItem expense =
          ExpenseItem(name: name, amount: amount, dateTime: dateTime);

          allExpense.add(expense);
    }

    return allExpense;
  }
}
