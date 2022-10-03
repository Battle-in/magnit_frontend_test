import 'package:hive/hive.dart';
import 'package:store/models/characteristics_model.dart';
import 'package:store/models/product_model.dart';
import 'package:store/models/shop_model.dart';
import 'package:store/resources/box_names.dart';
import 'package:store/service/network_requests.dart';

class GetData {
  static final GetData _getData = GetData._internal();

  factory GetData() => _getData;

  GetData._internal();

  Future<List<Shop>> getAllDataFromMemory() async {
    try{
      return Hive.box<Shop>(BoxNames.shopsBox).values.toList();
    } catch (e){
      rethrow;
    }
  }

  Future<List<Shop>> getAllDataFromNetwork() async {
    try {
      final dynamic shops = await getAllShops();
      final dynamic products = await getAllProducts();
      final dynamic characteristics = await getAllCharacteristics();

      final Box shopsBox = Hive.box<Shop>(BoxNames.shopsBox);
      final Box productsBox = Hive.box<Product>(BoxNames.productsBox);
      final Box characteristicsBox = Hive.box<Characteristics>(BoxNames.characteristicBox);

      List<Characteristics> newCharacteristics = _getNewCharacteristics(characteristics);

      characteristicsBox
        ..clear()
        ..addAll(newCharacteristics);

      List<Product> newProducts = _getNewProducts(products, characteristicsBox, newCharacteristics);

      productsBox
        ..clear()
        ..addAll(newProducts);

      List<Shop> newShops = _getNewShops(shops, productsBox, newProducts);

      shopsBox
        ..clear()
        ..addAll(newShops);

      Hive.box(BoxNames.lastLoadDateTime).put(0, DateTime.now().toString());

      return newShops;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  List<Characteristics> _getNewCharacteristics(dynamic characteristics){
    List<Characteristics> newCharacteristics = <Characteristics>[];

    for (var characteristic in characteristics) {
      newCharacteristics.add(Characteristics(characteristic['id'], characteristic['weight']));
    }

    return newCharacteristics;
  }

  List<Product> _getNewProducts(dynamic products, Box characteristicsBox, List<Characteristics> newCharacteristics){
    List<Product> newProducts = <Product>[];

    for (var product in products) {
      List<Characteristics> currentCharacteristics = <Characteristics>[];

      for (var character in product['characteristics']){
        currentCharacteristics.add(newCharacteristics[character]);
      }
      print(currentCharacteristics);
      newProducts.add(Product(product['id'], product['name'], HiveList<Characteristics>(characteristicsBox, objects: currentCharacteristics)));
    }

    return newProducts;
  }

  List<Shop> _getNewShops(dynamic shops, Box productsBox, List<Product> newProducts){
    List<Shop> newShops = <Shop>[];

    for (var shop in shops) {
      List<Product> currentProduct = <Product>[];

      for(var product in shop['products']){
        currentProduct.add(newProducts[product]);
      }

      newShops.add(Shop(shop['id'], shop['name'], HiveList<Product>(productsBox, objects: currentProduct)));

      currentProduct = [];
    }

    return newShops;
  }
}

