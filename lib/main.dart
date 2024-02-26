import 'package:flutter/material.dart';
import 'package:flutter_table_example/router.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MainApp());
}

final GoRouter router = AppRouter.router;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
            0xFFF6C812,
          <int, Color>{
            50: Color(0xFFF6C812),
            100: Color(0xFFF6C812),
            200: Color(0xFFF6C812),
            300: Color(0xFFF6C812),
            400: Color(0xFFF6C812),
            500: Color(0xFFF6C812),
            600: Color(0xFFF6C812),
            700: Color(0xFFF6C812),
            800: Color(0xFFF6C812),
            900: Color(0xFFF6C812),
          },
        ),
        // accentColor: const Color(0xFF0091D5),
        backgroundColor: Colors.white,
        cardColor: Colors.white,
        errorColor: Colors.red,
        ),
        primaryColor: const Color(0xFF335287),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(const Color(0xFF335287)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(const Color(0xFF335287)),
          ),
        ),
        // iconTheme: const IconThemeData(
        //   color: Color(0xFF0091D5),
        // ),
        // iconButtonTheme: IconButtonThemeData(
        //   style: ButtonStyle(
        //     // backgroundColor: MaterialStateProperty.all(const Color(0xFFF6C812)),
        //     foregroundColor: MaterialStateProperty.all(const Color(0xFF0091D5)),
        //   ),
        // ),
        // navigationDrawerTheme: NavigationDrawerThemeData(
        //   // backgroundColor: Color(0xFF0091D5),
        //   elevation: 0,
        //   iconTheme: MaterialStateProperty.all(const IconThemeData(color: Color(0xFF0091D5))),
        // ),
      ),
    );
  }
}
