part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitialized extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileLoaded({this.wallpaper = "", required this.thumbnail, required this.name, required this.balance});

  String wallpaper;
  String thumbnail;
  String name;
  String balance;

  @override 
  List<Object> get props => [wallpaper, thumbnail, name, balance];
}
