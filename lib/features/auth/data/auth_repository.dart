import 'dart:async';
import 'dart:io';

import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SocialProvider { apple, google }

abstract interface class AuthRepository {
  String? get currentUserId;

  Stream<String?> get userChanges;

  Future<Result<void>> sendEmailCode(String email);

  Future<Result<void>> verifyEmailCode({
    required String email,
    required String code,
  });

  Future<Result<void>> signInWith(SocialProvider provider);

  Future<Result<void>> signOut();
}

abstract final class AuthMessages {
  static const offline = 'No signal. Try again when you’re back online.';
  static const badCode = "That code didn't work. Check it or send a new one.";
  static const tooMany = 'Too many tries. Wait a minute and try again.';
  static const unavailable = "Sign-in isn't set up in this build.";
  static const generic = 'Something went wrong. Try again.';
}

class SupabaseAuthRepository implements AuthRepository {
  new(this._client);

  static const redirectUrl = 'sharedplates://login-callback';

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  String? get currentUserId => _auth.currentUser?.id;

  @override
  Stream<String?> get userChanges =>
      _auth.onAuthStateChange.map((s) => s.session?.user.id).distinct();

  @override
  Future<Result<void>> sendEmailCode(String email) => _guard(
    'sendEmailCode',
    () => _auth.signInWithOtp(email: email.trim().toLowerCase()),
  );

  @override
  Future<Result<void>> verifyEmailCode({
    required String email,
    required String code,
  }) => _guard(
    'verifyEmailCode',
    () => _auth.verifyOTP(
      type: OtpType.email,
      email: email.trim().toLowerCase(),
      token: code,
    ),
  );

  @override
  Future<Result<void>> signInWith(SocialProvider provider) =>
      _guard('signInWith', () async {
        final launched = await _auth.signInWithOAuth(switch (provider) {
          SocialProvider.apple => OAuthProvider.apple,
          SocialProvider.google => OAuthProvider.google,
        }, redirectTo: redirectUrl);
        if (!launched) throw const AuthException(AuthMessages.generic);
        return launched;
      });

  @override
  Future<Result<void>> signOut() => _guard('signOut', _auth.signOut);

  Future<Result<void>> _guard(
    String source,
    Future<Object?> Function() call,
  ) async {
    try {
      await call();
      return const Result.ok(null);
    } on AuthException catch (e, s) {
      ErrorReporter.report('AuthRepository.$source', e, s);
      return Result.error(Exception(_messageFor(e)));
    } on SocketException {
      return Result.error(Exception(AuthMessages.offline));
    } on TimeoutException {
      return Result.error(Exception(AuthMessages.offline));
    } on Exception catch (e, s) {
      ErrorReporter.report('AuthRepository.$source', e, s);
      return Result.error(
        Exception(
          ErrorReporter.isConnectivity(e)
              ? AuthMessages.offline
              : AuthMessages.generic,
        ),
      );
    }
  }

  static String _messageFor(AuthException e) {
    final code = e.code ?? '';
    final status = e.statusCode ?? '';
    if (code == 'otp_expired' || code.contains('invalid')) {
      return AuthMessages.badCode;
    }
    if (status == '429' || code.contains('rate_limit')) {
      return AuthMessages.tooMany;
    }
    if (e is AuthRetryableFetchException) return AuthMessages.offline;
    return e.message.isEmpty ? AuthMessages.generic : e.message;
  }
}

class UnavailableAuthRepository implements AuthRepository {
  const new();

  static final _error = Result<void>.error(Exception(AuthMessages.unavailable));

  @override
  String? get currentUserId => null;

  @override
  Stream<String?> get userChanges => const Stream.empty();

  @override
  Future<Result<void>> sendEmailCode(String email) async => _error;

  @override
  Future<Result<void>> verifyEmailCode({
    required String email,
    required String code,
  }) async => _error;

  @override
  Future<Result<void>> signInWith(SocialProvider provider) async => _error;

  @override
  Future<Result<void>> signOut() async => const Result.ok(null);
}
