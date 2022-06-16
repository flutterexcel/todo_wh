import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todoBloc/todoEvent.dart';
import 'package:todo/bloc/todoBloc/todoState.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitialState()) {
    on<TodoShowEvent>((event, emit) {
      if (event.categ != 'All tasks') {
        emit(ShowCategoryTaskState(event.categ));
      } else {
        emit(TodoShowState());
      }
    });
    on<TaskIsCompletedEvent>((event, emit) {
      print('in task is completed event >>> ');
      emit(TaskIsCompletedState());
    });
    on<ShowDeleteButtonEvent>(((event, emit) {
      emit(ShowDeleteButtonState());
    }));
  }
}
