abstract class TodoState {}

class TodoInitialState extends TodoState {}

class TodoShowState extends TodoState {}

class ShowCategoryTaskState extends TodoState {
  String catg;
  ShowCategoryTaskState(this.catg);
}

class TodoIsEmpty extends TodoState {}

class TaskIsCompletedState extends TodoState {
  @override
  List<Object> get props => [];
}

class ShowDeleteButtonState extends TodoState {}
