import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';

enum EmailStep { email, code }

class EmailSignInState extends Equatable {
  const new({
    this.step = EmailStep.email,
    this.email = '',
    this.code = '',
    this.sending = const DelayedResult.idle(),
    this.verifying = const DelayedResult.idle(),
    this.resendIn = 0,
    this.resent = false,
  });

  static const codeLength = 6;
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  final EmailStep step;
  final String email;
  final String code;
  final DelayedResult<bool> sending;
  final DelayedResult<bool> verifying;
  final int resendIn;
  final bool resent;

  bool get resending => step == EmailStep.code && sending.isInProgress;

  bool get emailValid => _emailPattern.hasMatch(email.trim());

  bool get codeComplete => code.length == codeLength;

  bool get canResend => resendIn == 0 && !sending.isInProgress;

  EmailSignInState copyWith({
    EmailStep? step,
    String? email,
    String? code,
    DelayedResult<bool>? sending,
    DelayedResult<bool>? verifying,
    int? resendIn,
    bool? resent,
  }) => EmailSignInState(
    step: step ?? this.step,
    email: email ?? this.email,
    code: code ?? this.code,
    sending: sending ?? this.sending,
    verifying: verifying ?? this.verifying,
    resendIn: resendIn ?? this.resendIn,
    resent: resent ?? this.resent,
  );

  @override
  List<Object?> get props => [
    step,
    email,
    code,
    sending,
    verifying,
    resendIn,
    resent,
  ];
}

class EmailSignInCubit extends Cubit<EmailSignInState> {
  new(this._auth, {this.resendSeconds = 60}) : super(const EmailSignInState());

  final AuthRepository _auth;
  final int resendSeconds;
  Timer? _countdown;

  void emailChanged(String value) =>
      emit(state.copyWith(email: value, sending: const DelayedResult.idle()));

  Future<void> submitEmail() async {
    if (!state.emailValid || state.sending.isInProgress) return;
    await _send(moveToCode: true);
  }

  Future<void> resend() async {
    if (!state.canResend) return;
    emit(
      state.copyWith(
        code: '',
        verifying: const DelayedResult.idle(),
        resent: false,
      ),
    );
    await _send(moveToCode: false);
  }

  Future<void> _send({required bool moveToCode}) async {
    emit(state.copyWith(sending: const DelayedResult.inProgress()));
    final result = await _auth.sendEmailCode(state.email);
    if (isClosed) return;
    switch (result) {
      case Error<void>(:final error):
        emit(
          state.copyWith(sending: DelayedResult.fromError(error.cleanError)),
        );
      case CastError<void>(:final error):
        emit(
          state.copyWith(sending: DelayedResult.fromError(error.cleanError)),
        );
      case Ok<void>():
        emit(
          state.copyWith(
            sending: const DelayedResult.fromValue(true),
            step: moveToCode ? EmailStep.code : state.step,
            resendIn: resendSeconds,
            resent: !moveToCode,
          ),
        );
        _startCountdown();
    }
  }

  void _startCountdown() {
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.resendIn - 1;
      if (next <= 0) timer.cancel();
      if (!isClosed) emit(state.copyWith(resendIn: next < 0 ? 0 : next));
    });
  }

  Future<void> codeChanged(String value) async {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final code = digits.length > EmailSignInState.codeLength
        ? digits.substring(0, EmailSignInState.codeLength)
        : digits;
    emit(state.copyWith(code: code, verifying: const DelayedResult.idle()));
    if (state.codeComplete) await verify();
  }

  Future<void> verify() async {
    if (!state.codeComplete || state.verifying.isInProgress) return;
    emit(state.copyWith(verifying: const DelayedResult.inProgress()));
    final result = await _auth.verifyEmailCode(
      email: state.email,
      code: state.code,
    );
    if (isClosed) return;
    switch (result) {
      case Error<void>(:final error):
        emit(
          state.copyWith(verifying: DelayedResult.fromError(error.cleanError)),
        );
      case CastError<void>(:final error):
        emit(
          state.copyWith(verifying: DelayedResult.fromError(error.cleanError)),
        );
      case Ok<void>():
        emit(state.copyWith(verifying: const DelayedResult.fromValue(true)));
    }
  }

  void changeEmail() {
    _countdown?.cancel();
    emit(
      state.copyWith(
        step: EmailStep.email,
        code: '',
        resendIn: 0,
        sending: const DelayedResult.idle(),
        verifying: const DelayedResult.idle(),
      ),
    );
  }

  @override
  Future<void> close() async {
    _countdown?.cancel();
    await super.close();
  }
}
