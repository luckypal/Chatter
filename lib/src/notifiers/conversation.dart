import 'package:flutter/material.dart';

class ConversationNotifier with ChangeNotifier {
  ConversationNotifier();
  
  void update() {
    notifyListeners();
  }
}
