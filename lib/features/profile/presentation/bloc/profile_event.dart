import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent {
  final bool isRefresh;
  const FetchProfileEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? email;
  final String? mobile;
  final String? profileImagePath;

  const UpdateProfileEvent({
    this.name,
    this.email,
    this.mobile,
    this.profileImagePath,
  });

  @override
  List<Object?> get props => [name, email, mobile, profileImagePath];
}

class DeleteAccountEvent extends ProfileEvent {}
