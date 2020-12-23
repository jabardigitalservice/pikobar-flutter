import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NPSModel.dart';
import 'package:pikobar_flutter/repositories/NPSRepository.dart';

part 'NPSState.dart';

class NPSCubit extends Cubit<NPSState> {
  NPSCubit() : super(NPSInitial());
  
  Future<void> saveNPS(NPSModel npsData) async {
    emit(NPSLoading());
    try {
      await NPSRepository.saveNPS(npsData: npsData);
      emit(NPSSaved());
    } catch (e) {
      emit(NPSFailed(e.toString()));
    }
  }
}
