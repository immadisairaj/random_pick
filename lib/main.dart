import 'package:flutter/material.dart';
import 'package:random_pick/features/random/presentation/pages/random_page.dart';
import 'package:random_pick/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

/// main application widget
class MyApp extends StatelessWidget {
  /// create the main application
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Pick',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.dark,
      ),
      // TODO(immadisairaj): add theme change option
      // themeMode: ThemeMode.light,
      home: const RandomPage(),
    );
  }
}
