import 'package:flutter/material.dart';

class BottomNavViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void selectTab(int index) {
    if (index == _selectedIndex || index < 0 || index > 2) return;
    _selectedIndex = index;
    notifyListeners();
  }
}
