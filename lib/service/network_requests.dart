import 'package:dio/dio.dart';
import 'package:store/resources/api_routes.dart';


Dio _dio = Dio();

Future<dynamic> getAllShops() async {
  try{
    print(ApiRoutes.shopApiRoute);
    Response response = await _dio.get(ApiRoutes.shopApiRoute);
    return response.data;
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getShopByIndex(int index) async {
  try{
    Response response = await _dio.get(ApiRoutes.shopByIndexApiRoute + index.toString());
    return response.data;
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getAllProducts() async {
  try{
    Response response = await _dio.get(ApiRoutes.productApiRoute);
    return response.data;
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getProductByIndex(int index) async {
  try{
    Response response = await _dio.get(ApiRoutes.productByIndexApiRoute + index.toString());
    return response.data;
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getAllCharacteristics() async {
  try{
    Response response = await _dio.get(ApiRoutes.characteristicsApiRoute);
    return response.data;
  } catch (exp){
    rethrow;
  }
}

Future<dynamic> getCharacteristicsByIndex(int index) async {
  try{
    Response response = await _dio.get(ApiRoutes.characteristicsByIndexApiRoute + index.toString());
    return response.data;
  } catch (exp){
    rethrow;
  }
}