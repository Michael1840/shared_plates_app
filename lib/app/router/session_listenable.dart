import 'dart:async';

import 'package:flutter/foundation.dart';

class StreamListenable<T> extends ChangeNotifier {
  StreamListenable(Stream<T> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<T> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
