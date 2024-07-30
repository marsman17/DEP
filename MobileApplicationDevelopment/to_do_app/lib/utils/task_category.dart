import 'package:flutter/material.dart';

enum TaskCategory {
  education(Icons.school, Color.fromARGB(255, 30, 105, 167)),
  health(Icons.favorite, Color.fromARGB(255, 208, 26, 13)),
  home(Icons.home, Color.fromARGB(255, 119, 28, 144)),
  others(Icons.calendar_month_rounded, Color.fromARGB(255, 33, 162, 173)),
  personal(Icons.person, Color.fromARGB(255, 223, 223, 27)),
  shopping(Icons.shopping_bag, Color.fromARGB(255, 255, 17, 0)),
  social(Icons.people, Color.fromARGB(255, 82, 159, 22)),
  travel(Icons.flight, Color.fromARGB(255, 25, 111, 191)),
  work(Icons.work, Color.fromRGBO(116, 63, 2, 1));

  static TaskCategory stringToTaskCategory(String name) {
    try {
      return TaskCategory.values.firstWhere(
        (category) => category.name == name,
      );
    } catch (e) {
      return TaskCategory.others;
    }
  }

  final IconData icon;
  final Color color;
  const TaskCategory(this.icon, this.color);
}
