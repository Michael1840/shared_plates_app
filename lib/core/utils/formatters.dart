abstract final class Formatters {
  static String rands(int cents) => 'R${(cents / 100).round()}';

  static String? perPlate(int? cents) =>
      cents == null ? null : '${rands(cents)} a plate';

  static String minutes(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    return rest == 0 ? '$hours hr' : '$hours hr $rest min';
  }

  static String compact(int value) {
    if (value < 1000) return '$value';
    final k = value / 1000;
    final text = k >= 10 ? k.round().toString() : k.toStringAsFixed(1);
    return '${text.replaceAll(RegExp(r'\.0$'), '')}k';
  }

  static String shortName(String? name) {
    final parts = (name ?? '').trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) return parts.first;
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }

  static String initials(String? name) {
    final parts = (name ?? '').trim().split(RegExp(r'\s+'));
    final letters = [
      for (final p in parts.take(2))
        if (p.isNotEmpty) p[0],
    ].join();
    return letters.toUpperCase();
  }

  static String relativeDay(DateTime when, DateTime now) {
    final day = DateTime(when.year, when.month, when.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(day).inDays;
    if (diff <= 0) return 'today';
    if (diff == 1) return 'yesterday';
    if (diff < 7) {
      const names = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return names[when.weekday - 1];
    }
    return '$diff days ago';
  }
}
