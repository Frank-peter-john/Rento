import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rento/firebase_options.dart';
import 'package:rento/screens/account/account_items/settings/themes/theme_constants.dart';
import 'package:rento/screens/account/account_items/settings/themes/theme_provider.dart';
import 'screens/main/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rento',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: provider.themeMode,
        home: const MainScreen(),
      );
    });
  }
}
