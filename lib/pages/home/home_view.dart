import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          children: [_searchPanel(context), _shopList()],
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

  Widget _shopList() {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomePageLoaded) {
        return Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.shops[index].name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ));
              },
              separatorBuilder: (_, i) => const Divider(),
              itemCount: state.shops.length),
        );
      } else if (state is HomePageLoadingFailure) {
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
}
