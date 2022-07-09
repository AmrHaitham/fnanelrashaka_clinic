import 'package:flutter/material.dart';
class SelectedIndex with ChangeNotifier{
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int selectedIndex){
    _selectedIndex = selectedIndex;
    notifyListeners();
  }


}