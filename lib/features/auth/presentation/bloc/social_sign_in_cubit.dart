import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';

class SocialSignInState extends Equatable {
  const new({this.provider, this.launch = const DelayedResult.idle()});

  final SocialProvider? provider;
  final DelayedResult<bool> launch;

  @override
  List<Object?> get props => [provider, launch];
}

class SocialSignInCubit extends Cubit<SocialSignInState> {
  new(this._auth) : super(const SocialSignInState());

  final AuthRepository _auth;

  Future<void> signIn(SocialProvider provider) async {
    if (state.launch.isInProgress) return;
    emit(
      SocialSignInState(
        provider: provider,
        launch: const DelayedResult.inProgress(),
      ),
    );
    final result = await _auth.signInWith(provider);
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
