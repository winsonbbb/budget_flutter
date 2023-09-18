import 'package:flutter/material.dart';
import 'package:budget_flutter/data/hive_database.dart';
import 'package:budget_flutter/helper/date_time_helper.dart';
import 'package:budget_flutter/model/expense_item.dart';
import 'package:provider/provider.dart';

class ExpenseData extends ChangeNotifier {
  final db = HiveDataBase();
  List<ExpenseItem> allExpenseList = [];

  List<ExpenseItem> getAllExpenseList() {
    return allExpenseList;
  }

  void prepareData() {
    if (db.readData().isNotEmpty) {

      allExpenseList = db.readData();
    }
  }

  void addNewExpense(ExpenseItem expenseItem) {
    allExpenseList.add(expenseItem);
    notifyListeners();
    db.saveData(allExpenseList);
  }

  void deleteExpense(ExpenseItem expenseItem) {
    allExpenseList.remove(expenseItem);
    notifyListeners();
    db.saveData(allExpenseList);
  }

  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  DateTime startOfWeekDate() {
    DateTime? startOfweek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfweek = today.subtract(Duration(days: i));
      }
    }
    return startOfweek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailytExpenseSummary = {};

    for (var expense in allExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (dailytExpenseSummary.containsKey(date)) {
        double currentAmount = dailytExpenseSummary[date]!;
        currentAmount += amount;
        dailytExpenseSummary[date] = currentAmount;
      } else {
        dailytExpenseSummary.addAll({date: amount});
      }
    }

    return dailytExpenseSummary;
  }
}
