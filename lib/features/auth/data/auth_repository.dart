import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/native_identity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SocialProvider { apple, google }

class AuthUser extends Equatable {
  const new({
    required this.id,
    this.isAnonymous = false,
    this.email,
    this.provider,
  });

  final String id;
  final bool isAnonymous;
  final String? email;
  final String? provider;

  @override
  List<Object?> get props => [id, isAnonymous, email, provider];
}

abstract interface class AuthRepository {
  AuthUser? get currentUser;

  Stream<AuthUser?> get userChanges;

  Future<Result<void>> signInAnonymously();

  Future<Result<void>> signInWithPassword({
    required String email,
    required String password,
  });

  Future<Result<void>> sendEmailCode(String email);

  Future<Result<void>> verifyEmailCode({
    required String email,
    required String code,
  });

  Future<Result<void>> signInWith(SocialProvider provider);

  Future<Result<void>> signOut();

  Future<Result<void>> deleteAccount();
}

abstract final class AuthMessages {
  static const offline = 'No signal. Try again when you’re back online.';
  static const badCode = "That code didn't work. Check it or send a new one.";
  static const tooMany = 'Too many tries. Wait a minute and try again.';
  static const unavailable = "Sign-in isn't set up in this build.";
  static const generic = 'Something went wrong. Try again.';
}

class SupabaseAuthRepository implements AuthRepository {
  new(this._client, {this._native = const NoNativeIdentity()});

  static const redirectUrl = 'sharedplates://login-callback';

  final SupabaseClient _client;
  final NativeIdentity _native;

  GoTrueClient get _auth => _client.auth;

  @override
  AuthUser? get currentUser => _map(_auth.currentUser);

  @override
  Stream<AuthUser?> get userChanges =>
      _auth.onAuthStateChange.map((s) => _map(s.session?.user)).distinct();

  static AuthUser? _map(User? user) => user == null
      ? null
      : AuthUser(
          id: user.id,
          isAnonymous: user.isAnonymous,
          email: user.email,
          provider: user.appMetadata['provider'] as String?,
        );

  @override
  Future<Result<void>> signInAnonymously() =>
      _guard('signInAnonymously', _auth.signInAnonymously);

  @override
  Future<Result<void>> signInWithPassword({
    required String email,
    required String password,
  }) => _guard(
    'signInWithPassword',
    () => _auth.signInWithPassword(email: email, password: password),
  );

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
        final oauth = switch (provider) {
          SocialProvider.apple => OAuthProvider.apple,
          SocialProvider.google => OAuthProvider.google,
        };
        final native = switch (provider) {
          SocialProvider.apple => _native.supportsApple,
          SocialProvider.google => _native.supportsGoogle,
        };
        if (!native) {
          final launched = await _auth.signInWithOAuth(
            oauth,
            redirectTo: redirectUrl,
          );
          if (!launched) throw const AuthException(AuthMessages.generic);
          return launched;
        }
        final grant = switch (provider) {
          SocialProvider.apple => await _native.apple(),
          SocialProvider.google => await _native.google(),
        };
        if (grant == null) return null;
        return await _auth.signInWithIdToken(
          provider: oauth,
          idToken: grant.idToken,
          accessToken: grant.accessToken,
          nonce: grant.rawNonce,
        );
      });

  @override
  Future<Result<void>> signOut() => _guard('signOut', _auth.signOut);

  @override
  Future<Result<void>> deleteAccount() => _guard('deleteAccount', () async {
    await _client.rpc<void>('delete_my_account');
    await _auth.signOut();
    return null;
  });

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
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> get userChanges => const Stream.empty();

  @override
  Future<Result<void>> signInAnonymously() async => _error;

  @override
  Future<Result<void>> signInWithPassword({
    required String email,
    required String password,
  }) async => _error;

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

  @override
  Future<Result<void>> deleteAccount() async => _error;
}
