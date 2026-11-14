import 'package:uuid/uuid.dart';

abstract final class Ids {
  static const _uuid = Uuid();

  static String next() => _uuid.v7();
}
