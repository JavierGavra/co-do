import 'package:codo/core/bloc/provider.dart';
import 'package:codo/core/theme/theme.dart';
import 'package:codo/features/menu/views/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID');
    return MultiBlocProvider(
      providers: Provider.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          fontFamily: "Inter",
          colorScheme: MaterialTheme.lightScheme(),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          fontFamily: "Inter",
          colorScheme: MaterialTheme.darkScheme(),
          useMaterial3: true,
        ),
        home: const MenuPage(),
      ),
    );
  }
}
