import 'package:az_listview/app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      ),
      home: const HomeScreen(),
    );
  }
}
