import 'package:flutter/material.dart';
import 'package:store/models/product_model.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Пордукт'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(product.name, style: Theme.of(context).textTheme.headline4,),
          ),
          Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index){
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(product.characteristics[index].weight.toString(), style: Theme.of(context).textTheme.headline6),
                      ),
                    );
                  },
                  separatorBuilder: (_, i) => const Divider(),
                  itemCount: product.characteristics.length
              ))
        ],
      ),
    );
  }
}
