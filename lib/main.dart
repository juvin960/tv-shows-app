import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Features/locator.dart';
import 'Features/presentation/view model/show_view_model.dart';
import 'Features/presentation/view/show_list_screen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //  Setup all GetIt dependencies before runApp
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide ShowViewModel from GetIt
        ChangeNotifierProvider<ShowViewModel>(
          create: (_) => sl<ShowViewModel>(),
        ),

      ],
      child: MaterialApp(
        title: 'TV Shows App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
          fontFamily: 'PlusJakartaSans',
        ),
        home: const HomePage(),
      ),
    );
  }
}
