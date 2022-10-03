import 'package:store/models/characteristics_model.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject{
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final HiveList<Characteristics> characteristicsId;

  Product(this.id, this.name, this.characteristicsId);

  factory Product.fromMap(Map<String, dynamic> map){
    //TODO: make this normal
    return Product(map['id'], map['name'], map['characteristics']);
  }

  Map toMap(){
    return {
      'id': id,
      'name': name,
      'characteristics': characteristicsId
    };
  }
}