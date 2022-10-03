import 'package:hive/hive.dart';

part 'characteristics_model.g.dart';

@HiveType(typeId: 1)
class Characteristics extends HiveObject{
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double weight;

  Characteristics(this.id, this.weight);

  factory Characteristics.fromMap(Map<String, dynamic> map){
    return Characteristics(map['id'], map['weight']);
  }

  Map toMap(){
    return {
      'id': id,
      'weight': weight
    };
  }
}