import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/models/characteristics_model.dart';
import 'package:store/models/product_model.dart';
import 'package:store/models/shop_model.dart';
import 'package:store/pages/home/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [_searchPanel(context), _bottomSide()],
        ),
      ),
    );
  }

  Widget _searchPanel(BuildContext context) {
    final TextEditingController nameFieldController = TextEditingController();
    final TextEditingController weightFieldController = TextEditingController();
    final FocusNode weightFocusNode = FocusNode();

    InputDecoration fieldDecoration = const InputDecoration(
      border: OutlineInputBorder(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.black26,
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              onSubmitted: (a) => weightFocusNode.requestFocus(),
              controller: nameFieldController,
              decoration: fieldDecoration.copyWith(hintText: 'Сыр', label: const Text('Наименование продукта')),
            ),
            TextField(
              //onChanged: (a) => {context.read<HomeBloc>().add(event)},
              keyboardType: TextInputType.number,
              controller: weightFieldController,
              focusNode: weightFocusNode,
              decoration: fieldDecoration.copyWith(hintText: '0.4', label: const Text('Вес продукта')),
            )
          ],
        ),
      ),
    );
  }


  Widget _bottomSide() {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomePageLoadedFromMemory) {
        _showSnackBarMessage(context, 'последнее обновление: ${state.lastDateUpdate}');
        return _listShops(state.shops);
      } else if (state is HomePageLoaded) {
        return _listShops(state.shops);
      } else if (state is HomePageLoadingFailure) {
        _showSnackBarMessage(context, state.message);
        return const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Icon(Icons.mood_bad_sharp),
        );
      } else {
        return const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }

  Widget _listShops(List<Shop> shops) =>
      Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: List.generate(shops.length, (index) {
            String subtitle = '';
            for (int i = 0; i < shops[index].products.length; i++) {
              Product product = shops[index].products[i];

              subtitle += '${product.name} (';
              for (int l = 0; l < product.characteristics.length; l++){
                  subtitle += product.characteristics[l].weight.toString();
                  if (l < product.characteristics.length - 1){
                    subtitle += ', ';
                  }
              }
              subtitle += ')';
              if (i < shops[index].products.length - 1){
                subtitle += '\n ';
              }
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(8)
              ),
                padding: const EdgeInsets.only(left: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(shops[index].name),
                    subtitle: Text(subtitle),
                  ),
                );
          }),
        ),
      );


  _showSnackBarMessage(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
