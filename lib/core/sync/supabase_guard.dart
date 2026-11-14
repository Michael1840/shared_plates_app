import 'dart:async';
import 'dart:io';

import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _timeout = Duration(seconds: 20);
const _permanentPrefixes = ['22', '23', '42', 'P0'];
const _transientPostgrest = {
  'PGRST000',
  'PGRST001',
  'PGRST002',
  'PGRST003',
  'PGRST301',
  'PGRST302',
};

Future<T> supabaseGuard<T>(Future<T> Function() call) async {
  try {
    return await call().timeout(_timeout);
  } on PostgrestException catch (e) {
    final code = e.code ?? '';
    final permanent =
        _permanentPrefixes.any(code.startsWith) ||
        (code.startsWith('PGRST') && !_transientPostgrest.contains(code));
    throw RemoteFailure(e.message, isTransient: !permanent, code: code);
  } on StorageException catch (e) {
    final status = int.tryParse(e.statusCode ?? '') ?? 0;
    final permanent =
        status >= 400 &&
        status < 500 &&
        !const {401, 408, 429}.contains(status);
    throw RemoteFailure(e.message, isTransient: !permanent, code: e.statusCode);
  } on AuthException catch (e) {
    throw RemoteFailure(e.message, isTransient: true, code: e.code);
  } on SocketException catch (e) {
    throw RemoteFailure(e.message, isTransient: true);
  } on TimeoutException {
    throw const RemoteFailure('Timed out', isTransient: true);
  } on HttpException catch (e) {
    throw RemoteFailure(e.message, isTransient: true);
  } on Exception catch (e) {
    throw RemoteFailure(e.toString(), isTransient: true);
  }
}
