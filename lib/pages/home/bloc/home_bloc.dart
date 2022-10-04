import 'dart:async';

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
  Stream<HomeState>? storeLoadStream;

  HomeBloc() : super(HomeInitial()) {
    on<StoreLoadEvent>((event, emitter) async {
      storeLoadStream = _storeLoadHandler(event);
      storeLoadStream!.listen((state) => emit(state));
    });

    on<FilterEvent>(_filterEventHandler);
  }

  Stream<HomeState> _storeLoadHandler(StoreLoadEvent event) async* {
    yield const HomeLoading();

    try {
      List<Shop> shops = await GetData().getAllDataFromNetworkAndSave();
      yield HomePageLoaded(shops);
    } catch (e) {
      String lastDateUpdate = Hive.box(BoxNames.lastLoadDateTime).get(0, defaultValue: 'empty');
      if (lastDateUpdate == 'empty') {
        yield HomePageLoadingFailure(e.toString());
      } else {
        yield HomePageLoadedFromMemory(lastDateUpdate, await GetData().getAllDataFromMemory());
      }
    }
  }

  HomePageFiltered _onlyNameFilter(List<Shop> shops, String productName) {
    List<Shop> filteredShops = [];
    List<Product> searchableProduct = [];

    for (Shop shop in shops) {
      for (Product product in shop.products) {
        if (product.name.toLowerCase().contains(productName)) {
          searchableProduct.add(product);
          filteredShops.add(shop);
          break;
        }
      }
    }

    return HomePageFiltered(productName, '', shops, filteredShops, searchableProduct);
  }

  HomePageFiltered _onlyWeightFilter(List<Shop> shops, String weight) {
    List<Shop> filteredShops = [];
    List<Product> searchableProduct = [];

    double doubleWeight = double.parse(weight);

    for (Shop shop in shops) {
      for (Product product in shop.products) {
        for (Characteristics characteristics in product.characteristics) {
          if (characteristics.weight == doubleWeight) {
            searchableProduct.add(product);
            filteredShops.add(shop);
            break;
          }
        }
      }
    }

    return HomePageFiltered('', weight, shops, filteredShops, searchableProduct);
  }

  HomePageFiltered _nameAndWeightFilter(List<Shop> shops, String productName, String weight) {
    List<Shop> filteredShops = [];
    List<Product> searchableProduct = [];

    double doubleWeight = double.parse(weight);

    for (Shop shop in shops) {
      for (Product product in shop.products) {
        if (product.name.toLowerCase().contains(productName)) {
          for (Characteristics characteristics in product.characteristics) {
            if (characteristics.weight == doubleWeight) {
              searchableProduct.add(product);
              filteredShops.add(shop);
              break;
            }
          }
        }
      }
    }

    return HomePageFiltered(productName, weight, shops, filteredShops, searchableProduct);
  }

  Future<void> _filterEventHandler(FilterEvent event, Emitter emitter) async {
    emitter(const HomeLoading());

    if (event.weight != '' && event.productName != '') {
      emitter(_nameAndWeightFilter(event.shops, event.productName, event.weight));
    } else if (event.weight == '' && event.productName != '') {
      emitter(_onlyNameFilter(event.shops, event.productName));
    } else if (event.weight != '' && event.productName == '') {
      emitter(_onlyWeightFilter(event.shops, event.weight));
    } else {
      emitter(HomePageLoaded(event.shops));
    }
  }
}
