part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoad extends HomeState {
  const HomeLoad();

  @override
  List<Object?> get props => [];
}

class HomePageLoaded extends HomeState {
  const HomePageLoaded(this.shops);

  final List<Shop> shops;

  @override
  List<Object?> get props => [shops];
}

class HomePageLoadingFailure extends HomeState {
  const HomePageLoadingFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
