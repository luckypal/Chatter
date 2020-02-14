import 'package:intl/intl.dart';

class Utilities {
  static String makeStandardPhoneNumber(String phoneNumber) {
    String newNumber = phoneNumber.replaceAllMapped(new RegExp(r"^(\+)|[^\d\n]"), (match) {
      if (match.group(1) == null) return '';
      return '${match.group(1)}';
    });
    
    if (!newNumber.startsWith("+"))
      newNumber = '+$newNumber';
      
    return newNumber;
  }

  static String formatTime(int milliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat.jm().format(dateTime);
  }
}
