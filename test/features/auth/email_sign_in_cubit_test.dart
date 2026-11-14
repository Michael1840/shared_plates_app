import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/email_sign_in_cubit.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAuthRepository auth;

  setUp(() => auth = MockAuthRepository());

  const email = 'thandi@example.com';

  blocTest<EmailSignInCubit, EmailSignInState>(
    'ignores an invalid email',
    build: () => EmailSignInCubit(auth),
    act: (c) async {
      c.emailChanged('not-an-email');
      await c.submitEmail();
    },
    expect: () => [const EmailSignInState(email: 'not-an-email')],
    verify: (_) => verifyNever(() => auth.sendEmailCode(any())),
  );

  blocTest<EmailSignInCubit, EmailSignInState>(
    'sends a code and moves to the code step',
    setUp: () =>
        when(() => auth.sendEmailCode(email))
            .thenAnswer((_) async => const Result.ok(null)),
    build: () => EmailSignInCubit(auth, resendSeconds: 30),
    act: (c) async {
      c.emailChanged(email);
      await c.submitEmail();
    },
    skip: 1,
    expect: () => [
      const EmailSignInState(email: email, sending: DelayedResult.inProgress()),
      const EmailSignInState(
        step: EmailStep.code,
        email: email,
        sending: DelayedResult.fromValue(true),
        resendIn: 30,
      ),
    ],
  );

  blocTest<EmailSignInCubit, EmailSignInState>(
    'shows the error when the code cannot be sent',
    setUp: () => when(() => auth.sendEmailCode(email))
        .thenAnswer((_) async => Result.error(Exception(AuthMessages.offline))),
    build: () => EmailSignInCubit(auth),
    act: (c) async {
      c.emailChanged(email);
      await c.submitEmail();
    },
    skip: 2,
    expect: () => [
      const EmailSignInState(
        email: email,
        sending: DelayedResult.fromError(AuthMessages.offline),
      ),
    ],
  );

  blocTest<EmailSignInCubit, EmailSignInState>(
    'verifies as soon as six digits are entered',
    setUp: () =>
        when(() => auth.verifyEmailCode(email: email, code: '482913'))
            .thenAnswer((_) async => const Result.ok(null)),
    build: () => EmailSignInCubit(auth),
    seed: () => const EmailSignInState(step: EmailStep.code, email: email),
    act: (c) => c.codeChanged('48-29 13'),
    expect: () => [
      const EmailSignInState(
        step: EmailStep.code,
        email: email,
        code: '482913',
      ),
      const EmailSignInState(
        step: EmailStep.code,
        email: email,
        code: '482913',
        verifying: DelayedResult.inProgress(),
      ),
      const EmailSignInState(
        step: EmailStep.code,
        email: email,
        code: '482913',
        verifying: DelayedResult.fromValue(true),
      ),
    ],
  );

  blocTest<EmailSignInCubit, EmailSignInState>(
    'keeps the error for a wrong code',
    setUp: () => when(() => auth.verifyEmailCode(email: email, code: '000000'))
        .thenAnswer((_) async => Result.error(Exception(AuthMessages.badCode))),
    build: () => EmailSignInCubit(auth),
    seed: () => const EmailSignInState(step: EmailStep.code, email: email),
    act: (c) => c.codeChanged('000000'),
    skip: 2,
    expect: () => [
      const EmailSignInState(
        step: EmailStep.code,
        email: email,
        code: '000000',
        verifying: DelayedResult.fromError(AuthMessages.badCode),
      ),
    ],
  );

  blocTest<EmailSignInCubit, EmailSignInState>(
    'counts down before allowing a resend',
    setUp: () =>
        when(() => auth.sendEmailCode(email))
            .thenAnswer((_) async => const Result.ok(null)),
    build: () => EmailSignInCubit(auth, resendSeconds: 1),
    act: (c) async {
      c.emailChanged(email);
      await c.submitEmail();
    },
    wait: const Duration(milliseconds: 1200),
    verify: (c) {
      expect(c.state.resendIn, 0);
      expect(c.state.canResend, isTrue);
    },
  );

  blocTest<EmailSignInCubit, EmailSignInState>(
    'changing the email returns to the first step',
    build: () => EmailSignInCubit(auth),
    seed: () => const EmailSignInState(
      step: EmailStep.code,
      email: email,
      code: '12',
      resendIn: 40,
    ),
    act: (c) => c.changeEmail(),
    expect: () => [const EmailSignInState(email: email)],
  );
}
