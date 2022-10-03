import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store/app.dart';
import 'package:store/models/characteristics_model.dart';
import 'package:store/models/product_model.dart';
import 'package:store/models/shop_model.dart';
import 'package:store/resources/box_names.dart';

main() async {
  await Hive.initFlutter();
  ///registration all adapters
  Hive.registerAdapter(CharacteristicsAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ShopAdapter());

  ///open all boxes
  await Hive.openBox<Characteristics>(BoxNames.characteristicBox);
  await Hive.openBox<Product>(BoxNames.productsBox);
  await Hive.openBox<Shop>(BoxNames.shopsBox);
  await Hive.openBox(BoxNames.lastLoadDateTime);

  runApp(const App());
}