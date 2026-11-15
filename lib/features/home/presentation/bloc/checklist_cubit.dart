import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/features/home/data/checklist_repository.dart';

class ChecklistCubit extends Cubit<ChecklistProgress?> {
  ChecklistCubit(this._repository) : super(null);

  final ChecklistRepository _repository;
  StreamSubscription<ChecklistProgress>? _sub;

  void watch(String uid) {
    unawaited(_sub?.cancel());
    _sub = _repository.watch(uid).listen((p) {
      if (!isClosed) emit(p);
    });
  }

  Future<void> dismiss() => _repository.dismiss();

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await super.close();
  }
}
