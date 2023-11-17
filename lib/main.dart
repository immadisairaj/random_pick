import 'package:flex_color_scheme/flex_color_scheme.dart';
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
    const colorScheme = FlexScheme.aquaBlue;
    var lightTheme = FlexThemeData.light(scheme: colorScheme);
    lightTheme = lightTheme.copyWith(
      scaffoldBackgroundColor: lightTheme.colorScheme.background
          .blend(lightTheme.appBarTheme.backgroundColor!, 15),
    );
    var darkTheme = FlexThemeData.dark(scheme: colorScheme);
    darkTheme = darkTheme.copyWith(
      scaffoldBackgroundColor: darkTheme.colorScheme.background
          .blend(darkTheme.appBarTheme.backgroundColor!, 15),
    );
    return MaterialApp(
      title: 'Random Pick',
      // debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // TODO(immadisairaj): add theme change option
      // themeMode: ThemeMode.dark,
      home: const RandomPage(),
    );
  }
}
