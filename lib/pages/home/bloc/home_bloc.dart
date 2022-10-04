import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:store/resources/box_names.dart';
import 'package:store/service/hive_layer.dart';

import '../../../models/shop_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<StoreLoadEvent>(_storeLoadHandler);
  }

  void _storeLoadHandler(StoreLoadEvent event, Emitter emitter) async {
    emit(const HomeLoading());
    
    try{
      List<Shop> shops = await GetData().getAllDataFromNetworkAndSave();
      emit(HomePageLoaded(shops));
    } catch (e) {
      String lastDateUpdate = Hive.box(BoxNames.lastLoadDateTime).get(0, defaultValue: 'empty');
      if (lastDateUpdate == 'empty') {
        emit(HomePageLoadingFailure(e.toString()));
      } else {
        emit(HomePageLoadedFromMemory(lastDateUpdate, await GetData().getAllDataFromMemory()));
      }
    }
  }
}
