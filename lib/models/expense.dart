import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { food, travel, leisure, work }

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  @override
  String toString() {
    return "Expense $title , amount $amount";
  }
}

extension Categoryicons on Category {
  IconData get Icon {
    switch (this) {
      case Category.food:
        return Icons.coffee;
      case Category.travel:
        return Icons.flight;
      case Category.leisure:
        return Icons.shopping_bag;
      case Category.work:
        return Icons.work;
    }
  }
}
