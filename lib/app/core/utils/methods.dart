import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../ui/layouts/page_container.dart';
import 'extensions.dart';

class Formatter {}

class Methods {
  static void showBottomSheet(BuildContext context, Widget child) =>
      showModalBottomSheet(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: context.background,
        isDismissible: true,
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        sheetAnimationStyle: AnimationStyle(
          duration: 500.ms,
          curve: Curves.easeIn,
        ),
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (context) => PageContainer.scrollable(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.primaryLoadingContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                child,
              ],
            ),
          ),
        ),
      );
}

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
