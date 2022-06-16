import 'package:flutter/material.dart';

abstract class TodoEvent {}

class TodoShowEvent extends TodoEvent {
  String categ;
  TodoShowEvent(this.categ);
}

class TodoIsEmptyEvent extends TodoEvent {
  String docs;
  TodoIsEmptyEvent(this.docs);
}

class TaskIsCompletedEvent extends TodoEvent {}

class ShowDeleteButtonEvent extends TodoEvent {}
