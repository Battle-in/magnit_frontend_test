import 'package:hive/hive.dart';
import 'package:store/models/characteristics_model.dart';
import 'package:store/models/product_model.dart';
import 'package:store/models/shop_model.dart';
import 'package:store/resources/box_names.dart';
import 'package:store/service/network_requests.dart';

Future<List<Shop>> getAllDataFromNetwork() async {
  try {
    final dynamic shops = await getAllShops();
    final dynamic products = await getAllProducts();
    final dynamic characteristics = await getAllCharacteristics();

    final Box shopsBox = Hive.box<Shop>(BoxNames.shopsBox);
    final Box productsBox = Hive.box<Product>(BoxNames.productsBox);
    final Box characteristicsBox = Hive.box<Characteristics>(BoxNames.characteristicBox);

    List<Shop> newShops = <Shop>[];
    List<Product> newProducts = <Product>[];
    List<Characteristics> newCharacteristics = <Characteristics>[];

    for (var characteristic in characteristics) {
      newCharacteristics.add(Characteristics(characteristic['id'], characteristic['weight']));
    }

    characteristicsBox
      ..clear()
      ..addAll(newCharacteristics);

    for (var product in products) {
      newProducts.add(Product(product['id'], product['name'], HiveList<Characteristics>(characteristicsBox, objects: newCharacteristics)));
    }

    productsBox
      ..clear()
      ..addAll(newProducts);

    for (var shop in shops) {
      newShops.add(Shop(shop['id'], shop['name'], HiveList<Product>(productsBox, objects: newProducts)));
    }

    shopsBox
      ..clear()
      ..addAll(newShops);
    print(newShops);
    return newShops;
  } catch (e) {
    print(e);
    rethrow;
  }
}
