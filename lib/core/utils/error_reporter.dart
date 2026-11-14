import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

abstract final class ErrorReporter {
  static void report(String source, Object error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint(
        '[$source] $error${stackTrace == null ? '' : '\n$stackTrace'}',
      );
    }
  }

  static bool isConnectivity(Object error) => switch (error) {
    SocketException() || TimeoutException() || HttpException() => true,
    _ => error.toString().contains('SocketException'),
  };
}
