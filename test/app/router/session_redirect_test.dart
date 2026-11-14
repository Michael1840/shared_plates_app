import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/app/router/app_router.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';

void main() {
  group('sessionRedirect', () {
    test('holds on the splash while the session is unknown', () {
      expect(
        sessionRedirect(SessionStatus.unknown, Routes.home),
        Routes.splash,
      );
      expect(sessionRedirect(SessionStatus.unknown, Routes.splash), isNull);
    });

    test('signed out users only see welcome and sign-in', () {
      expect(
        sessionRedirect(SessionStatus.signedOut, Routes.home),
        Routes.welcome,
      );
      expect(sessionRedirect(SessionStatus.signedOut, Routes.signIn), isNull);
    });

    test('guests can browse tabs and return to welcome', () {
      expect(sessionRedirect(SessionStatus.guest, Routes.discover), isNull);
      expect(sessionRedirect(SessionStatus.guest, Routes.welcome), isNull);
      expect(sessionRedirect(SessionStatus.guest, Routes.splash), Routes.home);
      expect(
        sessionRedirect(SessionStatus.guest, Routes.onboardingYou),
        Routes.home,
      );
    });

    test('new users are kept in onboarding', () {
      expect(
        sessionRedirect(SessionStatus.onboarding, Routes.home),
        Routes.onboardingYou,
      );
      expect(
        sessionRedirect(SessionStatus.onboarding, Routes.onboardingTaste),
        isNull,
      );
    });

    test('signed in users skip auth and onboarding', () {
      expect(
        sessionRedirect(SessionStatus.signedIn, Routes.welcome),
        Routes.home,
      );
      expect(
        sessionRedirect(SessionStatus.signedIn, Routes.onboardingFriends),
        Routes.home,
      );
      expect(sessionRedirect(SessionStatus.signedIn, Routes.recipes), isNull);
    });
  });
}
