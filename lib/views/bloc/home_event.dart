part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class AddWeight extends HomeEvent {
  final String? weight;
  final String? time;
  AddWeight({this.weight, this.time});
}

class UpdateWeight extends HomeEvent {
  final dynamic id;
  final String? weight;
  final String? time;
  UpdateWeight({this.id, this.weight, this.time});
}

class DeleteWeight extends HomeEvent {
  final dynamic id;

  DeleteWeight({this.id});
}

class FetchWeights extends HomeEvent {}