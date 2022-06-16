import 'package:flutter_bloc/flutter_bloc.dart';

import 'addBlocEvent.dart';
import 'addBlocState.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  AddBloc() : super(TaskNotAddedState()) {
    on<TextOnchangeEvent>((event, emit) {
      emit(TaskAddedState());
    });

    on<TaskAddedEvent>((event, emit) => TaskAddedState());

    on<AddCategoryEvent>((event, emit) => AddCategoryState());

    on<DeleteCategoryEvent>((event, emit) => DeleteCategoryState());

    on<TaskIsEmptyEvent>((event, emit) => TaskIsEmpty('Enter the task first'));
  }
}
