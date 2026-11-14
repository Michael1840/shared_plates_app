import 'dart:async';
import 'dart:io';

import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _timeout = Duration(seconds: 20);
const _permanentPrefixes = ['22', '23', '42', 'P0'];

Future<T> supabaseGuard<T>(Future<T> Function() call) async {
  try {
    return await call().timeout(_timeout);
  } on PostgrestException catch (e) {
    final code = e.code ?? '';
    final permanent = _permanentPrefixes.any(code.startsWith);
    throw RemoteFailure(e.message, isTransient: !permanent, code: code);
  } on StorageException catch (e) {
    throw RemoteFailure(e.message, isTransient: true, code: e.statusCode);
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
