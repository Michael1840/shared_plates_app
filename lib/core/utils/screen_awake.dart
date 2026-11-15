import 'package:wakelock_plus/wakelock_plus.dart';

abstract interface class ScreenAwake {
  Future<void> keepOn();

  Future<void> release();
}

class WakelockScreenAwake implements ScreenAwake {
  const WakelockScreenAwake();

  @override
  Future<void> keepOn() => WakelockPlus.enable();

  @override
  Future<void> release() => WakelockPlus.disable();
}
