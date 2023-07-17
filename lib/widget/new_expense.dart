import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpense();
}

class _NewExpense extends State<NewExpense> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.lesiure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _sumbitExpenseData() {
    final enteredAmount = double.tryParse(amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount and date enetered is incorrect...'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('okay'))
                ],
              ));
      return;
    }
    widget.onAddExpense(Expense(
        title: titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboard + 16),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          prefixText: '\$ ', label: Text('Amount')),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_selectedDate == null
                          ? 'No date selected'
                          : formatter.format(_selectedDate!)),
                      IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month))
                    ],
                  ))
                ],
              ),
              const SizedBox(),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase())))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () => _sumbitExpenseData(),
                      child: const Text('Save Expense'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
