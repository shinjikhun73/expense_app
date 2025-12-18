import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  DateTime? _selectedDate;

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _amountController.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void onCreate() {
    //  1 Build an expense
    String title = _titleController.text;
    double? amount = double.tryParse(_amountController.text); // amount
    Category category = _selectedCategory; // done for icons
    DateTime? date = _selectedDate;
    if (title.isEmpty || amount == null || amount <= 0) {
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Please enter a valid title and amount greater than 0.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    Expense newExpense = Expense(
      title: title,
      amount: amount,
      date: date!,
      category: category,
    );

    // pop to the parent done!
    Navigator.pop(context, newExpense);
  }

  void onCancel() {
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              const SizedBox(height: 10),

            _selectedDate == null ? Text(
                "No Date Selected"
            ) : Text("Date: ${DateFormat.yMMMd().format(_selectedDate!)}"),
              
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => selectDate(context),
                  child: const Icon(Icons.calendar_month),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          //DropdownButton for category
          DropdownButton<Category>(
            value: _selectedCategory,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            items: Category.values.map<DropdownMenuItem<Category>>((
              Category value,
            ) {
              return DropdownMenuItem<Category>(
                value: value,
                child: Text(value.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (newCategory) {
              setState(() {
                _selectedCategory = newCategory!;
              });
            },
          ),

          ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onCreate, child: Text("Create")),
        ],
      ),
    );
  }
}
