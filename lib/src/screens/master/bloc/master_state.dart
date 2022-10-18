part of 'master_bloc.dart';

class MasterState extends Equatable {
  const MasterState(
    {
      this.pageIndex = 0
    }
  );

  final int pageIndex;

  MasterState copyWith(
    {
      int? pageIndex
    }
  ){
    return MasterState(
      pageIndex: pageIndex ?? this.pageIndex
    );
  }

  @override
  List<Object?> get props => [
    pageIndex
  ];
}
