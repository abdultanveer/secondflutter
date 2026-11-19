import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier {

  int counter = 0; //jammes bond

  void increment() {
    print('increment method called');
    counter++;

    notifyListeners();
  }
}