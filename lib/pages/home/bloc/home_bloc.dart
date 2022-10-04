import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:store/models/characteristics_model.dart';
import 'package:store/models/product_model.dart';
import 'package:store/resources/box_names.dart';
import 'package:store/service/hive_layer.dart';

import 'package:store/models/shop_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<StoreLoadEvent>(_storeLoadHandler);
    on<FilterEvent>(_filterEventHandler);
  }

  Future<void> _storeLoadHandler(StoreLoadEvent event, Emitter emitter) async {
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

  Future<void> _filterEventHandler(FilterEvent event, Emitter emitter) async {
    emit(HomeLoading());

    List<Shop> filteredShops = [];

    if (event.weight != '' && event.productName != ''){
      filteredShops = _nameAndWeightFilter(event.shops, event.productName, event.weight);
    } else if (event.weight == '' && event.productName != ''){
      filteredShops = _onlyNameFilter(event.shops, event.productName);
    } else if (event.weight != '' && event.productName == ''){
      filteredShops = _onlyWeightFilter(event.shops, event.weight);
    } else {
      filteredShops = event.shops;
    }

    emit(HomePageFiltered(event.productName, event.weight, event.shops, filteredShops));
  }

  List<Shop> _onlyNameFilter(List<Shop> shops, String productName){
    List<Shop> filteredShops = [];

    for (Shop shop in shops){
      for (Product product in shop.products){
        if (product.name.toLowerCase().contains(productName)){
          filteredShops.add(shop);
          break;
        }
      }
    }

    return filteredShops;
  }

  List<Shop> _onlyWeightFilter(List<Shop> shops, String weight){
    List<Shop> filteredShops = [];

    double doubleWeight = double.parse(weight);

    for (Shop shop in shops){
      for (Product product in shop.products){
        for (Characteristics characteristics in product.characteristics){
          if (characteristics.weight == doubleWeight){
            filteredShops.add(shop);
            break;
          }
        }
      }
    }

    return filteredShops;
  }

  List<Shop> _nameAndWeightFilter(List<Shop> shops, String productName, String weight){
    List<Shop> filteredShops = [];

    double doubleWeight = double.parse(weight);

    for (Shop shop in shops){
      for (Product product in shop.products){
        if (product.name.toLowerCase().contains(productName)){
          for (Characteristics characteristics in product.characteristics){
            if (characteristics.weight == doubleWeight){
              filteredShops.add(shop);
              break;
            }
          }
        }
      }
    }

    return filteredShops;
  }
}
