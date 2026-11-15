import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';

class SocialSignInState extends Equatable {
  const SocialSignInState({
    this.provider,
    this.launch = const DelayedResult.idle(),
  });

  final SocialProvider? provider;
  final DelayedResult<bool> launch;

  @override
  List<Object?> get props => [provider, launch];
}

class SocialSignInCubit extends Cubit<SocialSignInState> {
  SocialSignInCubit(this._auth) : super(const SocialSignInState());

  final AuthRepository _auth;

  Future<void> signIn(SocialProvider provider) =>
      _run(provider, () => _auth.signInWith(provider));

  Future<void> signInWithTestAccount({
    required String email,
    required String password,
  }) => _run(
    null,
    () => _auth.signInWithPassword(email: email, password: password),
  );

  Future<void> _run(
    SocialProvider? provider,
    Future<Result<void>> Function() call,
  ) async {
    if (state.launch.isInProgress) return;
    emit(
      SocialSignInState(
        provider: provider,
        launch: const DelayedResult.inProgress(),
      ),
    );
    final result = await call();
    if (isClosed) return;
    switch (result) {
      case Error<void>(:final error):
        emit(
          SocialSignInState(
            provider: provider,
            launch: DelayedResult.fromError(error.cleanError),
          ),
        );
      case CastError<void>(:final error):
        emit(
          SocialSignInState(
            provider: provider,
            launch: DelayedResult.fromError(error.cleanError),
          ),
        );
      case Ok<void>():
        emit(
          SocialSignInState(
            provider: provider,
            launch: const DelayedResult.fromValue(true),
          ),
        );
    }
  }
}
