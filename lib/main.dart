import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gps_app/blocs/gps/gps_bloc.dart';
import 'package:flutter_gps_app/screens/screens.dart';

void main() {
  // proveemos el bloc a la aplicacion lo mas alto posible en el arbol
  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (context) => GpsBloc())],
    child: const MapsApp(),
  ));
}

class MapsApp extends StatelessWidget {
  const MapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maps App',
        home: LoadingScreen());
  }
}
