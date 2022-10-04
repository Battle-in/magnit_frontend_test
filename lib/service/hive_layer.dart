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
    try {
     var shops = Hive.box<Shop>(BoxNames.shopsBox).values.toList();
     return shops;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Shop>> getAllDataFromNetworkAndSave() async {
    try {
      final shopsFromNet = await getAllShops();
      final productsFromNet = await getAllProducts();
      final characteristicsFromNet = await getAllCharacteristics();

      List<Characteristics> newCharacteristics = await _refreshSavedCharacteristics(characteristicsFromNet);
      List<Product> newProducts = await _refreshSavedProduct(productsFromNet, newCharacteristics);
      List<Shop> newShops = await _refreshSavedShops(shopsFromNet, newProducts);

      Hive.box(BoxNames.lastLoadDateTime).put(0, DateTime.now().toString());

      return newShops;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Shop>> _refreshSavedShops(var shopsFromNet, List<Product> products) async {
    Box shopBox = Hive.box<Shop>(BoxNames.shopsBox);
    Box productBox = Hive.box<Product>(BoxNames.productsBox);
    List<Shop> newShops = [];

    for (var shop in shopsFromNet){
      HiveList<Product> shopProducts = HiveList<Product>(productBox);

      for (var productId in shop['products']){
        shopProducts.add(products[productId]);
      }

      newShops.add(Shop(shop['id'], shop['name'], shopProducts));
    }

    await shopBox.clear();
    await shopBox.addAll(newShops);

    return newShops;
  }

  Future<List<Product>> _refreshSavedProduct(var productsFromNet, List<Characteristics> characteristics) async {
    Box productBox = Hive.box<Product>(BoxNames.productsBox);
    Box characteristicsBox = Hive.box<Characteristics>(BoxNames.characteristicBox);
    List<Product> newProducts = [];

    for (var product in productsFromNet){
      HiveList<Characteristics> productCharacteristics = HiveList<Characteristics>(characteristicsBox);

      for (var characteristicId in product['characteristics']){
        productCharacteristics.add(characteristics[characteristicId]);
      }

      newProducts.add(Product(product['id'], product['name'], productCharacteristics));
    }

    await productBox.clear();
    await productBox.addAll(newProducts);

    return newProducts;
  }

  Future<List<Characteristics>> _refreshSavedCharacteristics(var characteristicsFromNet) async {
    try{
      Box characteristicsBox = Hive.box<Characteristics>(BoxNames.characteristicBox);
      List<Characteristics> newCharacteristics = [];

      for (var element in characteristicsFromNet){
        newCharacteristics.add(Characteristics(element['id'], element['weight']));
      }

      await characteristicsBox.clear();
      await characteristicsBox.addAll(newCharacteristics);

      return newCharacteristics;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
