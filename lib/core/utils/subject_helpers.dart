import 'package:flutter/material.dart';

IconData iconForSubject(String subject) {
  switch (subject.toLowerCase()) {
    case 'mathematics':
      return Icons.calculate;
    case 'biology':
      return Icons.science;
    case 'english':
      return Icons.book;
    case 'chemistry':
      return Icons.biotech;
    case 'physics':
      return Icons.lightbulb;
    case 'history':
      return Icons.history_edu;
    default:
      return Icons.school;
  }
}
