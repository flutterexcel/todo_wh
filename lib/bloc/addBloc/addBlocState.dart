abstract class AddState {}

class TaskAddedState extends AddState {}

class TaskNotAddedState extends AddState {}

class TaskIsEmpty extends AddState {
  String errorMessage;
  TaskIsEmpty(this.errorMessage);
}

class DeleteCategoryState extends AddState {}

class AddCategoryState extends AddState {}
