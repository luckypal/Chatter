import 'package:chatter/src/models/user/base.dart';
import 'package:flutter/material.dart';

class UIColors {
  static Color userStatusColor(UserState userState) {
    switch(userState) {
      case UserState.available: return Colors.green;
      case UserState.away: return Colors.orange;
      case UserState.busy: return Colors.red;
      case UserState.unknown: return Colors.transparent;
    }
    return Colors.transparent;
  }
}