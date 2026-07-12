import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/models/user_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded || event.isRefresh) {
      if (!event.isRefresh) {
        emit(ProfileLoading());
      }

      final result = await repository.getProfile();
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (user) => emit(ProfileLoaded(user)),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    UserModel? currentUser;
    if (currentState is ProfileLoaded) currentUser = currentState.user;
    if (currentState is ProfileUpdateSuccess) currentUser = currentState.user;

    emit(ProfileUpdating());

    final result = await repository.updateProfile(
      name: event.name,
      email: event.email,
      mobile: event.mobile,
      profileImagePath: event.profileImagePath,
    );

    result.fold(
      (failure) {
        emit(ProfileUpdateError(failure.message));
        if (currentUser != null) {
          emit(ProfileLoaded(currentUser));
        }
      },
      (user) {
        emit(ProfileUpdateSuccess(user));
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    UserModel? currentUser;
    if (currentState is ProfileLoaded) currentUser = currentState.user;
    
    emit(DeleteAccountLoading());

    final result = await repository.deleteAccount();

    result.fold(
      (failure) {
        emit(DeleteAccountError(failure.message));
        if (currentUser != null) {
          emit(ProfileLoaded(currentUser));
        }
      },
      (_) => emit(DeleteAccountSuccess()),
    );
  }
}
