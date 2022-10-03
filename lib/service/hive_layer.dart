
import 'package:store/models/product_model.dart';
import 'package:store/service/network_requests.dart';

Future<List<Product>> getAllDataFromNetwork() async {
  try{
    dynamic shops = getAllShops();
    dynamic products = getAllProducts();
    dynamic characteristic = getAllProducts();

    for (shops)
  } catch (e){
    rethrow;
  }
}