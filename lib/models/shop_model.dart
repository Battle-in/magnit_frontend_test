import 'package:store/models/product_model.dart';
import 'package:hive/hive.dart';

part 'shop_model.g.dart';

@HiveType(typeId: 3)
class Shop extends HiveObject{
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final HiveList<Product> products;

  Shop(this.id, this.name, this.products);

  factory Shop.fromMap(Map<String, dynamic> map){
    List<int> productsId = [];
    for (int element in map['products']){
      productsId.add(element);
    }
    return Shop(map['id'], map['name'], map['products']);
  }

  Map toMap(){
    return {
      'id': id,
      'name': name,
      'products': products
    };
  }
}