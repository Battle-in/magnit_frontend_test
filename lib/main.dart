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

  await Hive.openBox(BoxNames.characteristicBox);
  await Hive.openBox(BoxNames.productsBox);
  await Hive.openBox(BoxNames.shopsBox);

  runApp(const App());
}