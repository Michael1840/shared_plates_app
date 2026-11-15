import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/features/browse/data/browse_api.dart';

class CoverCache {
  CoverCache({
    required this._db,
    required this._api,
    Future<Directory> Function()? directory,
    HttpClient Function()? client,
    this.batchSize = 12,
  }) : _directory = directory ?? getApplicationSupportDirectory,
       _client = client ?? HttpClient.new;

  static const _timeout = Duration(seconds: 20);

  final AppDatabase _db;
  final BrowseApi _api;
  final Future<Directory> Function() _directory;
  final HttpClient Function() _client;
  final int batchSize;
  Future<void>? _running;

  Future<void> backfill(String uid) =>
      _running ??= _backfill(uid).whenComplete(() => _running = null);

  Future<void> _backfill(String uid) async {
    try {
      final saved = _db.selectOnly(_db.saves)
        ..addColumns([_db.saves.recipeId])
        ..where(_db.saves.userId.equals(uid));
      final rows =
          await (_db.select(_db.recipes)
                ..where(
                  (r) =>
                      r.coverPath.isNotNull() &
                      r.localCoverPath.isNull() &
                      r.deletedAt.isNull() &
                      (r.authorId.equals(uid) | r.id.isInQuery(saved)),
                )
                ..limit(batchSize))
              .get();
      if (rows.isEmpty) return;
      final urls = await _api.signCovers([for (final r in rows) r.coverPath!]);
      final dir = Directory('${(await _directory()).path}/covers');
      await dir.create(recursive: true);
      for (final row in rows) {
        final url = urls[row.coverPath];
        if (url == null) continue;
        final file = File(
          '${dir.path}/${row.id}-${row.coverPath.hashCode}.img',
        );
        final ok = await _download(url, file);
        if (!ok) continue;
        await (_db.update(_db.recipes)..where((t) => t.id.equals(row.id)))
            .write(RecipesCompanion(localCoverPath: Value(file.path)));
      }
    } on RemoteFailure catch (e, s) {
      ErrorReporter.report('CoverCache', e, s);
    } on IOException catch (e, s) {
      ErrorReporter.report('CoverCache', e, s);
    }
  }

  Future<bool> _download(String url, File file) async {
    final client = _client();
    try {
      final request = await client.getUrl(Uri.parse(url)).timeout(_timeout);
      final response = await request.close().timeout(_timeout);
      if (response.statusCode != HttpStatus.ok) {
        await response.drain<void>();
        return false;
      }
      final temp = File('${file.path}.part');
      await response.pipe(temp.openWrite());
      await temp.rename(file.path);
      return true;
    } on IOException catch (e, s) {
      ErrorReporter.report('CoverCache.download', e, s);
      return false;
    } on TimeoutException catch (e, s) {
      ErrorReporter.report('CoverCache.download', e, s);
      return false;
    } finally {
      client.close();
    }
  }
}
