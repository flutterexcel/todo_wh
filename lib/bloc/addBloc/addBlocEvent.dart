abstract class AddEvent {}

class TextOnchangeEvent extends AddEvent {
  String task;
  TextOnchangeEvent(this.task);
}

class TaskAddedEvent extends AddEvent {}

class TaskNotAddedEvent extends AddEvent {
  String task;
  TaskNotAddedEvent(this.task);
}

class TaskIsEmptyEvent extends AddEvent {}

class AddCategoryEvent extends AddEvent {}

class DeleteCategoryEvent extends AddEvent {}
