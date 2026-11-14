import 'package:shared_plates_app/core/domain/measure.dart';

abstract final class StepText {
  static const _minWord = 3;
  static const _skip = {'and', 'for', 'the', 'with', 'fresh', 'large', 'small'};

  static List<(String, bool)> highlight(String body, Iterable<String> names) {
    final ranges = <(int, int)>[];
    final lower = body.toLowerCase();
    for (final name in names) {
      final range = _find(lower, _core(name));
      if (range != null && !_overlaps(ranges, range)) ranges.add(range);
    }
    if (ranges.isEmpty) return [(body, false)];
    ranges.sort((a, b) => a.$1.compareTo(b.$1));
    final parts = <(String, bool)>[];
    var cursor = 0;
    for (final (start, end) in ranges) {
      if (start > cursor) parts.add((body.substring(cursor, start), false));
      parts.add((body.substring(start, end), true));
      cursor = end;
    }
    if (cursor < body.length) parts.add((body.substring(cursor), false));
    return parts;
  }

  static String _core(String raw) =>
      Measure.nameFrom(raw).split(RegExp('[,(]')).first.trim().toLowerCase();

  static (int, int)? _find(String haystack, String needle) {
    if (needle.isEmpty) return null;
    final words = needle.split(RegExp(r'\s+'));
    for (var from = 0; from < words.length; from++) {
      final phrase = words.sublist(from).join(' ');
      if (from == words.length - 1 && !_usable(phrase)) break;
      final hit = _wordMatch(haystack, phrase);
      if (hit != null) return hit;
    }
    for (final word in words.reversed) {
      if (!_usable(word)) continue;
      final hit =
          _wordMatch(haystack, word) ?? _wordMatch(haystack, _singular(word));
      if (hit != null) return hit;
    }
    return null;
  }

  static bool _usable(String word) =>
      word.length >= _minWord && !_skip.contains(word);

  static String _singular(String word) {
    if (word.endsWith('ies')) return '${word.substring(0, word.length - 3)}y';
    if (word.endsWith('oes')) return word.substring(0, word.length - 2);
    if (word.endsWith('s')) return word.substring(0, word.length - 1);
    return word;
  }

  static (int, int)? _wordMatch(String haystack, String needle) {
    final match = RegExp('\\b${RegExp.escape(needle)}(?:e?s)?\\b')
        .firstMatch(haystack);
    return match == null ? null : (match.start, match.end);
  }

  static bool _overlaps(List<(int, int)> ranges, (int, int) next) =>
      ranges.any((r) => next.$1 < r.$2 && r.$1 < next.$2);
}
