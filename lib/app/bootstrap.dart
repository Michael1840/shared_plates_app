import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_plates_app/app/app.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorReporter.report('Flutter', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorReporter.report('Platform', error, stack);
    return true;
  };

  SupabaseClient? client;
  if (Env.hasBackend) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseKey,
      debug: kDebugMode,
    );
    client = Supabase.instance.client;
  }
  configureDependencies(supabase: client);
  if (sl.isRegistered<SyncService>()) sl<SyncService>().start();

  runApp(const SharedPlatesApp());
}
