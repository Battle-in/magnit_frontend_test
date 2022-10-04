part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class StoreLoadEvent extends HomeEvent {
  const StoreLoadEvent();
}

class FilterEvent extends HomeEvent{
  final String productName;
  final String weight;
  final List<Shop> shops;

  const FilterEvent(this.productName, this.weight, this.shops);
}