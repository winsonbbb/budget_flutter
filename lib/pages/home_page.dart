import 'package:flutter/material.dart';
import 'package:budget_flutter/components/expense_summary.dart';
import 'package:budget_flutter/components/expense_tile.dart';
import 'package:budget_flutter/data/expense_data.dart';
import 'package:budget_flutter/model/expense_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add new expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newExpenseNameController,
                    decoration: const InputDecoration(hintText: "Expense name"),
                  ),
                  TextField(
                      controller: newExpenseAmountController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: "Expense Amount"))
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                )
              ],
            ));
  }

  void save() {
    if (newExpenseAmountController.text.isNotEmpty &&
        newExpenseNameController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: newExpenseAmountController.text,
          dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);

      Navigator.pop(context);
      clear();
    }
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void deleteExpense(ExpenseItem expenseItem) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
  }

  void clear() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: addNewExpense,
                child: const Icon(Icons.add),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    ExpenseSummary(startOfweek: value.startOfWeekDate()),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.getAllExpenseList().length,
                        itemBuilder: (context, index) => ExpenseTile(
                              name: value.getAllExpenseList()[index].name,
                              amount: value.getAllExpenseList()[index].amount,
                              dateTime:
                                  value.getAllExpenseList()[index].dateTime,
                              deleteTapped: (p0) => deleteExpense(
                                  value.getAllExpenseList()[index]),
                            ))
                  ],
                ),
              ),
            ));
  }
}
