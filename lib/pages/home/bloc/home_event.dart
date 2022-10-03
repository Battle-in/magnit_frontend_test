part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class StoreLoadEvent extends HomeEvent {
  const StoreLoadEvent();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}
