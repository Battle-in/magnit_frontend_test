import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store/service/network_requests.dart';

import '../../../models/shop_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<StoreLoadEvent>(_storeLoadHandler);
  }

  void _storeLoadHandler(StoreLoadEvent event, Emitter emitter) async {
    try{
      List<Shop> shops = await getAllShops();
      emit(HomePageLoaded(shops));
    } catch (e) {
      emit(HomePageLoadingFailure(e.toString()));
    }
  }
}
