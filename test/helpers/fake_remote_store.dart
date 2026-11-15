import 'dart:typed_data';

import 'package:shared_plates_app/core/sync/remote_store.dart';

class RemoteCall {
  const RemoteCall(this.method, this.target, this.payload);

  final String method;
  final String target;
  final Map<String, Object?> payload;

  @override
  String toString() => '$method $target $payload';
}

class FakeRemoteStore implements RemoteStore {
  FakeRemoteStore({this.userId});

  @override
  String? userId;

  final Map<String, List<JsonRow>> tables = {};
  final Map<String, List<String>> keys = {};
  final List<RemoteCall> calls = [];
  final List<RemoteFailure> failures = [];
  final Map<String, Object?> rpcResults = {};

  void seed(String table, List<JsonRow> rows, {List<String> key = const []}) {
    tables[table] = [...rows];
    keys[table] = key;
  }

  void _maybeFail() {
    if (failures.isNotEmpty) throw failures.removeAt(0);
  }

  bool _matches(JsonRow row, Map<String, Object?> match) =>
      match.entries.every((e) => row[e.key] == e.value);

  @override
  Future<void> upsert(
    String table,
    JsonRow row, {
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    calls.add(RemoteCall('upsert', table, row));
    _maybeFail();
    final rows = tables.putIfAbsent(table, () => []);
    final keyColumns =
        onConflict?.split(',') ?? keys[table] ?? const <String>['id'];
    final key = {for (final k in keyColumns) k: row[k]};
    final index = rows.indexWhere((r) => _matches(r, key));
    if (index == -1) {
      rows.add({...row});
    } else if (!ignoreDuplicates) {
      rows[index] = {...rows[index], ...row};
    }
  }

  final Map<String, int> uploads = {};

  @override
  Future<void> upsertMany(
    String table,
    List<JsonRow> rows, {
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    for (final row in rows) {
      await upsert(
        table,
        row,
        onConflict: onConflict,
        ignoreDuplicates: ignoreDuplicates,
      );
    }
  }

  @override
  Future<void> upload(
    String bucket,
    String path,
    Uint8List bytes, {
    required String contentType,
  }) async {
    calls.add(RemoteCall('upload', bucket, {'path': path}));
    _maybeFail();
    uploads['$bucket/$path'] = bytes.length;
  }

  @override
  Future<void> update(
    String table,
    JsonRow values, {
    required Map<String, Object> match,
  }) async {
    calls.add(RemoteCall('update', table, {...values, 'match': match}));
    _maybeFail();
    final rows = tables[table] ?? [];
    for (var i = 0; i < rows.length; i++) {
      if (_matches(rows[i], match)) rows[i] = {...rows[i], ...values};
    }
  }

  @override
  Future<void> delete(String table, Map<String, Object> match) async {
    calls.add(RemoteCall('delete', table, match));
    _maybeFail();
    tables[table]?.removeWhere((r) => _matches(r, match));
  }

  @override
  Future<Object?> rpc(String function, JsonRow params) async {
    calls.add(RemoteCall('rpc', function, params));
    _maybeFail();
    return rpcResults[function];
  }

  @override
  Future<List<JsonRow>> fetchChanged(
    String table, {
    required List<String> orderKeys,
    required int from,
    required int to,
    DateTime? since,
    Map<String, Object> match = const {},
  }) async {
    calls.add(RemoteCall('fetchChanged', table, {'from': from, 'to': to}));
    _maybeFail();
    final rows =
        [
          for (final r in tables[table] ?? const <JsonRow>[])
            if (_matches(r, match) &&
                (since == null ||
                    DateTime.parse(r['updated_at'] as String).isAfter(since)))
              r,
        ]..sort((a, b) {
          final byTime = (a['updated_at'] as String).compareTo(
            b['updated_at'] as String,
          );
          if (byTime != 0) return byTime;
          for (final k in orderKeys) {
            final c = '${a[k]}'.compareTo('${b[k]}');
            if (c != 0) return c;
          }
          return 0;
        });
    if (from >= rows.length) return [];
    return rows.sublist(from, to + 1 > rows.length ? rows.length : to + 1);
  }

  @override
  Future<List<JsonRow>> select(
    String table, {
    Map<String, Object> match = const {},
    String? orderBy,
    bool descending = true,
    int limit = 50,
  }) async {
    calls.add(RemoteCall('select', table, match));
    _maybeFail();
    final rows = [
      for (final r in tables[table] ?? const <JsonRow>[])
        if (_matches(r, match)) r,
    ];
    final order = orderBy;
    if (order != null) {
      rows.sort((a, b) {
        final c = '${a[order]}'.compareTo('${b[order]}');
        return descending ? -c : c;
      });
    }
    return rows.take(limit).toList();
  }

  @override
  Future<List<JsonRow>> fetchIn(
    String table, {
    required String column,
    required List<Object> values,
  }) async {
    calls.add(RemoteCall('fetchIn', table, {column: values}));
    _maybeFail();
    return [
      for (final r in tables[table] ?? const <JsonRow>[])
        if (values.contains(r[column])) r,
    ];
  }
}
