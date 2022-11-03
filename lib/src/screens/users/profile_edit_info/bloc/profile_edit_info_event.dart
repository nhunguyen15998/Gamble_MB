part of 'profile_edit_info_bloc.dart';

class ProfileEditInfoEvent extends Equatable {
  const ProfileEditInfoEvent();

  @override
  List<Object> get props => [];
}

class ProfileEditInfoInitial extends ProfileEditInfoEvent {}

class ProfileEditInfoUpdating extends ProfileEditInfoEvent {}
