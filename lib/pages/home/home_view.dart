import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/models/product_model.dart';
import 'package:store/models/shop_model.dart';
import 'package:store/pages/home/bloc/home_bloc.dart';
import 'package:store/pages/magazine_page.dart';
import 'package:store/service/formatters.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController weightFieldController = TextEditingController();
  final FocusNode weightFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        centerTitle: true,
        //actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => context.read<HomeBloc>().add(const StoreLoadEvent()))],
      ),
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state){
            return Column(
              children: [
                _searchPanel(context, state),
                _bottomSide(context, state)
              ],
            );
          },
        )
      ),
    );
  }

  Widget _searchPanel(BuildContext context, HomeState state) {
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
              enabled: state is HomePageLoaded,
              onChanged: (_) => _onFieldChanged(_, state, context),
              onSubmitted: (a) => weightFocusNode.requestFocus(),
              controller: nameFieldController,
              decoration: fieldDecoration.copyWith(hintText: 'Сыр', label: const Text('Наименование продукта')),
            ),
            TextField(
              inputFormatters: [InputDoubleFormatter()],
              enabled: state is HomePageLoaded,
              onChanged: (_) => _onFieldChanged(_, state, context),
              keyboardType: TextInputType.number,
              controller: weightFieldController,
              focusNode: weightFocusNode,
              decoration: fieldDecoration.copyWith(hintText: '0.4', label: const Text('Вес продукта')),
            ),
          ],
        ),
      ),
    );
  }

  _onFieldChanged(_, HomeState state, BuildContext context){
    if (state is HomePageLoaded){
      context.read<HomeBloc>().add(FilterEvent(nameFieldController.text,
          weightFieldController.text, state.shops));
    }
  }

  Widget _bottomSide(BuildContext context, HomeState state) {
      if (state is HomePageFiltered){
        return _listShops(state.filteredShops, context);
      } else if (state is HomePageLoadedFromMemory) {
        _showSnackBarMessage(context, 'последнее обновление: ${state.lastDateUpdate}');
        return _listShops(state.shops, context);
      } else if (state is HomePageLoaded) {
        return _listShops(state.shops, context);
      } else if (state is HomeLoading) {
        return const Padding(
          padding: EdgeInsets.only(top: 20),
          child: CircularProgressIndicator(),
        );
      } else if (state is HomePageLoadingFailure) {
        _showSnackBarMessage(context, 'Произошла ошибка сети, увы ранних данных на устройсте не обнаруженно');
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
  }

  Widget _listShops(List<Shop> shops, BuildContext context) => Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: List.generate(shops.length, (index) {
            String subtitle = '';
            for (int i = 0; i < shops[index].products.length; i++) {
              Product product = shops[index].products[i];

              subtitle += '${product.name} (';
              for (int l = 0; l < product.characteristics.length; l++) {
                subtitle += product.characteristics[l].weight.toString();
                if (l < product.characteristics.length - 1) {
                  subtitle += ', ';
                }
              }
              subtitle += ')';
              if (i < shops[index].products.length - 1) {
                subtitle += '\n ';
              }
            }


            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MagazinePage(shop: shops[index],)));
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(shops[index].name),
                  subtitle: Text(subtitle),
                ),
              ),
            );
          }),
        ),
      );

  _showSnackBarMessage(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
