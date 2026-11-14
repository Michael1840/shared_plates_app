abstract final class StepTimer {
  static const _words = {
    'a': 1.0,
    'an': 1.0,
    'one': 1.0,
    'two': 2.0,
    'three': 3.0,
    'four': 4.0,
    'five': 5.0,
    'six': 6.0,
    'seven': 7.0,
    'eight': 8.0,
    'nine': 9.0,
    'ten': 10.0,
    'twelve': 12.0,
    'fifteen': 15.0,
    'twenty': 20.0,
    'thirty': 30.0,
    'forty': 40.0,
    'forty-five': 45.0,
    'sixty': 60.0,
  };

  static final _halfHour = RegExp(r'\bhalf an? hour\b', caseSensitive: false);

  static final _amount = RegExp(
    r'(\d+(?:[.,]\d+)?|forty-five|[a-z]+)'
    r'(?:\s*(?:-|–|to)\s*(\d+(?:[.,]\d+)?))?'
    r'\s*(hours?|hrs?|h|minutes?|mins?|m|seconds?|secs?|s)\b',
    caseSensitive: false,
  );

  static int? secondsFor({required int? explicit, required String body}) {
    if (explicit != null && explicit > 0) return explicit;
    return parse(body);
  }

  static int? parse(String text) {
    if (_halfHour.hasMatch(text)) return 30 * 60;
    var total = 0.0;
    var lastEnd = -1;
    for (final match in _amount.allMatches(text)) {
      final raw = match.group(1)!;
      final value = _value(raw);
      if (value == null) continue;
      final wordy = double.tryParse(raw.replaceAll(',', '.')) == null;
      if (wordy && match.group(3)!.length == 1) continue;
      final gap = lastEnd < 0 ? '' : text.substring(lastEnd, match.start);
      final joins = lastEnd >= 0 && RegExp(r'^\s*(?:and\s*)?$').hasMatch(gap);
      if (total > 0 && !joins) break;
      total += value * _unitSeconds(match.group(3)!);
      lastEnd = match.end;
    }
    if (total <= 0 || total > 24 * 3600) return null;
    return total.round();
  }

  static double? _value(String raw) {
    final lower = raw.toLowerCase();
    return double.tryParse(lower.replaceAll(',', '.')) ?? _words[lower];
  }

  static int _unitSeconds(String unit) {
    final u = unit.toLowerCase();
    if (u.startsWith('h')) return 3600;
    if (u.startsWith('s')) return 1;
    return 60;
  }

  static String clock(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    final mm = m.toString().padLeft(h > 0 ? 2 : 1, '0');
    final ss = sec.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
  }
}
