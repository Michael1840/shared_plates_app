import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a Cubit/Bloc stream to a Listenable for GoRouter
class AuthRefreshListenable<T> extends ChangeNotifier {
  final Stream<T> _stream;
  late final StreamSubscription<T> _subscription;
  T? _lastState;

  AuthRefreshListenable(this._stream) {
    _subscription = _stream.listen((state) {
      // Only notify if state actually changed (optional optimization)
      if (state != _lastState) {
        _lastState = state;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
