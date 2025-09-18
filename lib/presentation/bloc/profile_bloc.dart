import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;

  ProfileBloc({
    required this.getUserProfile,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);

    add(LoadProfile());
  }

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    if (isClosed) return;

    emit(ProfileLoading());

    try {
      final result = await getUserProfile();

      if (isClosed) return;

      result.fold(
            (failure) {
          if (!isClosed) emit(ProfileError(failure.message));
        },
            (userProfile) {
          if (!isClosed) emit(ProfileLoaded(userProfile));
        },
      );
    } catch (e) {
      if (!isClosed) emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onRefreshProfile(
      RefreshProfile event,
      Emitter<ProfileState> emit,
      ) async {
    if (!isClosed) add(LoadProfile());
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
