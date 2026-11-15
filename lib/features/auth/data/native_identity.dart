import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class IdTokenGrant {
  const new({required this.idToken, this.accessToken, this.rawNonce});

  final String idToken;
  final String? accessToken;
  final String? rawNonce;
}

abstract interface class NativeIdentity {
  bool get supportsGoogle;

  bool get supportsApple;

  Future<IdTokenGrant?> google();

  Future<IdTokenGrant?> apple();
}

class DeviceNativeIdentity implements NativeIdentity {
  new({required this._webClientId, required this._iosClientId});

  static const _scopes = ['email', 'profile'];

  final String _webClientId;
  final String _iosClientId;
  Future<void>? _googleReady;

  @override
  bool get supportsGoogle =>
      _webClientId.isNotEmpty &&
      (Platform.isAndroid || (Platform.isIOS && _iosClientId.isNotEmpty));

  @override
  bool get supportsApple => Platform.isIOS;

  @override
  Future<IdTokenGrant?> google() async {
    final signIn = GoogleSignIn.instance;
    await (_googleReady ??= signIn.initialize(
      serverClientId: _webClientId,
      clientId: Platform.isIOS ? _iosClientId : null,
    ));
    try {
      final account = await signIn.authenticate(scopeHint: _scopes);
      final idToken = account.authentication.idToken;
      if (idToken == null) return null;
      final authorization =
          await account.authorizationClient.authorizationForScopes(_scopes) ??
          await account.authorizationClient.authorizeScopes(_scopes);
      return IdTokenGrant(
        idToken: idToken,
        accessToken: authorization.accessToken,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<IdTokenGrant?> apple() async {
    final rawNonce = _nonce();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
      );
      final idToken = credential.identityToken;
      if (idToken == null) return null;
      return IdTokenGrant(idToken: idToken, rawNonce: rawNonce);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }

  static String _nonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

class NoNativeIdentity implements NativeIdentity {
  const new();

  @override
  bool get supportsGoogle => false;

  @override
  bool get supportsApple => false;

  @override
  Future<IdTokenGrant?> google() async => null;

  @override
  Future<IdTokenGrant?> apple() async => null;
}
