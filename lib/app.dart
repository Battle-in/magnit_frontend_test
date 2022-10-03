import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/pages/home/bloc/home_bloc.dart';
import 'package:store/pages/home/home_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      routes: {
        '/' : (context) => BlocProvider<HomeBloc>(
            create: (_) => HomeBloc()..add(const StoreLoadEvent()),
            child: const HomePage(),
        ),
      },
    );
  }
}
