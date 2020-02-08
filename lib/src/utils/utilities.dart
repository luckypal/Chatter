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
}
