import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Features/locator.dart';
import 'Features/presentation/view model/show_view_model.dart';
import 'Features/presentation/view/show_list_screen.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //   GetIt dependencies setup
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShowViewModel>(
          create: (_) => sl<ShowViewModel>(),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, currentTheme, _) {
          return MaterialApp(
            title: 'TV Shows App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.red,
              useMaterial3: true,
              fontFamily: 'PlusJakartaSans',
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.red,
                unselectedItemColor: Colors.black54,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.red,
              useMaterial3: true,
              fontFamily: 'PlusJakartaSans',
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color(0xFF121212),
                selectedItemColor: Colors.red,
                unselectedItemColor: Colors.white54,
              ),
            ),
            themeMode: currentTheme, // switch based on ValueNotifier
            home: const HomePage(),
          );
        },
      ),
    );
  }

}
