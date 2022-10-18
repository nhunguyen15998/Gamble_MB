part of 'master_bloc.dart';

abstract class MasterEvent extends Equatable {
  const MasterEvent();

  @override
  List<Object> get props => [];  
}

class PageIndexChanged extends MasterEvent {
  const PageIndexChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object> get props => [pageIndex]; 
}
