import 'package:dio/dio.dart';
import 'package:store/models/characteristics_model.dart';
import 'package:store/models/product_model.dart';
import 'package:store/resources/api_routes.dart';

import '../models/shop_model.dart';

Dio _dio = Dio();

Future<dynamic> getAllShops() async {
  try{
    print(ApiRoutes.shopApiRoute);
    Response response = await _dio.get(ApiRoutes.shopApiRoute);
    return response.data;
    // List<Shop> res = <Shop>[];
    // for (var element in response.data){
    //   print(element);
    //   res.add(Shop.fromMap(element));
    // }
    //
    // return res;
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getShopByIndex(int index) async {
  try{
    Response response = await _dio.get(ApiRoutes.shopByIndexApiRoute + index.toString());
    return response.data;
    //return Shop.fromMap(response.data);
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getAllProducts() async {
  try{
    Response response = await _dio.get(ApiRoutes.productApiRoute);
    return response.data;
    // List<Product> res = <Product>[];
    //
    // for (var element in response.data){
    //   res.add(Product.fromMap(element));
    // }
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getProductByIndex(int index) async {
  try{
    Response response = await _dio.get(ApiRoutes.productByIndexApiRoute + index.toString());
    return response.data;
    return Product.fromMap(response.data);
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getAllCharacteristics() async {
  try{
    Response response = await _dio.get(ApiRoutes.characteristicsApiRoute);
    return response.data;
    List<Characteristics> res = <Characteristics>[];

    for (var element in response.data){
      res.add(Characteristics.fromMap(element));
    }

    return res;
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getCharacteristicsByIndex(int index) async {
  try{
    Response response = await _dio.get(ApiRoutes.characteristicsByIndexApiRoute + index.toString());
    return response.data;
    return Characteristics.fromMap(response.data);
  } catch (exp){
    rethrow;
  }
}