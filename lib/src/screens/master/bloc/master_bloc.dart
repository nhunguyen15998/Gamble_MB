import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'master_event.dart';
part 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  MasterBloc() : super(const MasterState()) {
    on<PageIndexChanged>(_mapPageIndexChangedToState);
  }

  void _mapPageIndexChangedToState(PageIndexChanged event, Emitter<MasterState> emit){
    final index = event.pageIndex;
    emit(state.copyWith(pageIndex: index));
  }

}
