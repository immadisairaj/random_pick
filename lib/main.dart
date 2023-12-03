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

  ThemeData _getThemeData(ThemeData copyFromTheme) {
    return copyFromTheme.copyWith(
      scaffoldBackgroundColor: copyFromTheme.colorScheme.background
          .blend(copyFromTheme.appBarTheme.backgroundColor!, 15),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return copyFromTheme.colorScheme.primary;
          }
          return null;
        }),
        shape: const StadiumBorder(),
      ),
      listTileTheme: const ListTileThemeData(
        shape: StadiumBorder(),
      ),
    );
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    const colorScheme = FlexScheme.aquaBlue;
    var lightTheme = FlexThemeData.light(scheme: colorScheme);
    lightTheme = _getThemeData(lightTheme);
    var darkTheme = FlexThemeData.dark(scheme: colorScheme);
    darkTheme = _getThemeData(darkTheme);
    return MaterialApp(
      title: 'Random Pick',
      // debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      // showSemanticsDebugger: true,
      // TODO(immadisairaj): add theme change option
      // themeMode: ThemeMode.dark,
      home: const RandomPage(),
    );
  }
}
