import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/data/native_identity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockClient extends Mock implements SupabaseClient {}

class _MockAuth extends Mock implements GoTrueClient {}

class _FakeNative implements NativeIdentity {
  _FakeNative({
    this.supportsGoogle = false,
    this.supportsApple = false,
    this.grant,
  });

  @override
  final bool supportsGoogle;
  @override
  final bool supportsApple;
  final IdTokenGrant? grant;
  int calls = 0;

  @override
  Future<IdTokenGrant?> google() async {
    calls++;
    return grant;
  }

  @override
  Future<IdTokenGrant?> apple() async {
    calls++;
    return grant;
  }
}

void main() {
  late _MockClient client;
  late _MockAuth auth;

  setUpAll(() => registerFallbackValue(OAuthProvider.google));

  setUp(() {
    client = _MockClient();
    auth = _MockAuth();
    when(() => client.auth).thenReturn(auth);
    when(
      () => auth.signInWithIdToken(
        provider: any(named: 'provider'),
        idToken: any(named: 'idToken'),
        accessToken: any(named: 'accessToken'),
        nonce: any(named: 'nonce'),
      ),
    ).thenAnswer((_) async => AuthResponse());
    when(
      () => auth.getOAuthSignInUrl(
        provider: any(named: 'provider'),
        redirectTo: any(named: 'redirectTo'),
        scopes: any(named: 'scopes'),
        queryParams: any(named: 'queryParams'),
      ),
    ).thenAnswer(
      (_) async => const OAuthResponse(
        provider: OAuthProvider.apple,
        url: 'https://example.com',
      ),
    );
  });

  test('native Google hands the ID token to Supabase', () async {
    final repo = SupabaseAuthRepository(
      client,
      native: _FakeNative(
        supportsGoogle: true,
        grant: const IdTokenGrant(idToken: 'id', accessToken: 'access'),
      ),
    );

    final result = await repo.signInWith(SocialProvider.google);

    expect(result, isA<Ok<void>>());
    verify(
      () => auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: 'id',
        accessToken: 'access',
      ),
    ).called(1);
    verifyNever(
      () => auth.getOAuthSignInUrl(
        provider: any(named: 'provider'),
        redirectTo: any(named: 'redirectTo'),
        scopes: any(named: 'scopes'),
        queryParams: any(named: 'queryParams'),
      ),
    );
  });

  test('native Apple sends the raw nonce', () async {
    final repo = SupabaseAuthRepository(
      client,
      native: _FakeNative(
        supportsApple: true,
        grant: const IdTokenGrant(idToken: 'apple-id', rawNonce: 'raw'),
      ),
    );

    await repo.signInWith(SocialProvider.apple);

    verify(
      () => auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: 'apple-id',
        nonce: 'raw',
      ),
    ).called(1);
  });

  test('closing the sheet is not an error', () async {
    final native = _FakeNative(supportsGoogle: true);
    final repo = SupabaseAuthRepository(client, native: native);

    final result = await repo.signInWith(SocialProvider.google);

    expect(result, isA<Ok<void>>());
    expect(native.calls, 1);
    verifyNever(
      () => auth.signInWithIdToken(
        provider: any(named: 'provider'),
        idToken: any(named: 'idToken'),
        accessToken: any(named: 'accessToken'),
        nonce: any(named: 'nonce'),
      ),
    );
  });

  test('falls back to the browser when native is not set up', () async {
    final repo = SupabaseAuthRepository(client, native: _FakeNative());

    await repo.signInWith(SocialProvider.apple);

    verify(
      () => auth.getOAuthSignInUrl(
        provider: OAuthProvider.apple,
        redirectTo: SupabaseAuthRepository.redirectUrl,
      ),
    ).called(1);
  });
}
