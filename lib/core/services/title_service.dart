import 'package:flutter/material.dart';

class TitleService {
  static final ValueNotifier<String> _titleNotifier = ValueNotifier('EduArc');

  static ValueNotifier<String> get titleNotifier => _titleNotifier;

  static void setTitle(String pageTitle) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newValue = pageTitle.isEmpty ? 'EduArc' : 'EduArc - $pageTitle';
      if (_titleNotifier.value != newValue) {
        _titleNotifier.value = newValue;
      }
    });
  }

  static String getCurrentTitle() {
    return _titleNotifier.value;
  }
}
