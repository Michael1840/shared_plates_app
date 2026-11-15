import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';

class CurrentProfileCubit extends Cubit<Profile?> {
  CurrentProfileCubit({required this._profiles, required SessionCubit session})
    : super(null) {
    _sessionSub = session.stream.listen(_onSession);
    _onSession(session.state);
  }

  final ProfileRepository _profiles;
  late final StreamSubscription<SessionState> _sessionSub;
  StreamSubscription<Profile?>? _profileSub;
  String? _uid;

  void _onSession(SessionState session) {
    final uid = session.userId;
    if (uid == _uid) return;
    _uid = uid;
    unawaited(_profileSub?.cancel());
    _profileSub = null;
    if (uid == null) {
      emit(null);
      return;
    }
    _profileSub = _profiles.watchProfile(uid).listen((p) {
      if (!isClosed) emit(p);
    });
  }

  @override
  Future<void> close() async {
    await _sessionSub.cancel();
    await _profileSub?.cancel();
    await super.close();
  }
}
