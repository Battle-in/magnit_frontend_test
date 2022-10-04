import 'package:flutter/material.dart';
import 'package:store/models/shop_model.dart';
import 'package:store/pages/product_page.dart';

class MagazinePage extends StatelessWidget {
  const MagazinePage({Key? key, required this.shop}) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Магазин'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(shop.name, style: Theme.of(context).textTheme.headline4,),
            ),
            Expanded(
                child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(product: shop.products[index],)));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(shop.products[index].name, style: Theme.of(context).textTheme.headline6),
                    ),
                  );
                },
                separatorBuilder: (_, i) => const Divider(),
                itemCount: shop.products.length
            ))
          ],
        ),
      ),
    );
  }
}
