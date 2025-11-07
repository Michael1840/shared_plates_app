import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../ui/layouts/page_container.dart';
import 'extensions.dart';

class Formatter {
  static String formatCreatedAt(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM').format(createdAt);
    }
  }
}

class Methods {
  static void showBottomSheet(
    BuildContext context,
    Widget child, {
    bool isFull = false,
  }) => showModalBottomSheet(
    barrierColor: Colors.black.withValues(alpha: 0.6),
    backgroundColor: context.background,
    isDismissible: true,
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    sheetAnimationStyle: AnimationStyle(duration: 250.ms, curve: Curves.easeIn),
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      final content = Padding(
        padding: EdgeInsets.only(
          bottom: bottomInset,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: isFull ? MainAxisSize.max : MainAxisSize.min,
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
            if (isFull) Expanded(child: child) else child,
          ],
        ),
      );

      // Only make it scrollable if it's not full
      return isFull ? content : PageContainer.scrollable(child: content);
    },
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
