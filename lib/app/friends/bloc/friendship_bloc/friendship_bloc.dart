import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'friendship_event.dart';
part 'friendship_state.dart';

class FriendshipBloc extends Bloc<FriendshipEvent, FriendshipState> {
  FriendshipBloc() : super(FriendshipInitial()) {
    on<FriendshipEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
