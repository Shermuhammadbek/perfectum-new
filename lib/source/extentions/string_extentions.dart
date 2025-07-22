extension PhoneNumberFormatter on String {
  /// Formats phone number to +998 (XX) XXX XX-XX pattern
  String formatPhoneNumber() {
    // Remove all non-digit characters
    final digitsOnly = replaceAll(RegExp(r'\D'), '');
    
    // Remove leading zeros
    final cleaned = digitsOnly.replaceFirst(RegExp(r'^0+'), '');
    
    // Handle different input cases
    String normalized;
    if (cleaned.startsWith('998')) {
      normalized = cleaned;
    } else if (cleaned.length <= 9) {
      // Assume it's local number without country code
      normalized = '998$cleaned';
    } else {
      // If it's some other format, just use as is
      normalized = cleaned;
    }
    
    // Apply formatting based on length
    final buffer = StringBuffer();
    final len = normalized.length;
    
    for (int i = 0; i < len && i < 12; i++) {
      if (i == 0) buffer.write('+');
      if (i == 3) buffer.write(' (');
      if (i == 5) buffer.write(') ');
      if (i == 8) buffer.write(' ');
      if (i == 10) buffer.write('-');
      buffer.write(normalized[i]);
    }
    
    return buffer.toString();
  }

  String formatPrice() {
    final number = int.tryParse(this);
    if (number == null) return this;
    
    final reversed = number.toString().split('').reversed.toList();
    final formatted = <String>[];
    
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formatted.add(' ');
      }
      formatted.add(reversed[i]);
    }
    
    return formatted.reversed.join('');
  }

}





String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.length != 12) {
    throw ArgumentError('Invalid phone number length. Must be 12 digits.');
  }

  final countryCode = phoneNumber.substring(0, 3);
  final areaCode = phoneNumber.substring(3, 5);
  final part1 = phoneNumber.substring(5, 8);
  final part2 = phoneNumber.substring(8, 10);
  final part3 = phoneNumber.substring(10, 12);

  return '+$countryCode($areaCode) $part1 $part2 $part3';
}