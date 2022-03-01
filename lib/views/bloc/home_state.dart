part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadingState extends HomeState {}

class ErrorState extends HomeState {
  final String? error;
  ErrorState({this.error});
}

class InfoMessage extends HomeState {
  final String? message;
  InfoMessage({this.message});
}

class WeightsFetched extends HomeState {
  final Stream<QuerySnapshot>? data;
  WeightsFetched({this.data});
}