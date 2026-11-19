import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/favorite_show.dart';
import 'screens/login_screen.dart';
import 'screens/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive (favorit)
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteShowAdapter());

  await Hive.openBox<FavoriteShow>('favorites');

  // (session login)
  final prefs = await SharedPreferences.getInstance();
  final isLogin = prefs.getBool('loginData') ?? false;

  runApp(MainApp(isLogin: isLogin));
}

class MainApp extends StatelessWidget {
  final bool isLogin;
  const MainApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keripikroll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5722),
          surface: Color(0xFF1C1C1E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xFFFF5722),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: isLogin ? const Root() : const LoginScreen(),
    );
  }
}
