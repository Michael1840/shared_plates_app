import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatter {}

class Methods {}

class DOBInputFormatter extends TextInputFormatter {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(
      RegExp(r'\D'),
      '',
    ); // Remove non-digit characters

    if (text.length > 8) {
      return oldValue; // If length exceeds 8, return the old value (to prevent too much input)
    }

    String formattedText = text;

    if (text.length >= 3) {
      formattedText = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    if (text.length >= 5) {
      formattedText =
          '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4)}';
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
