import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111827),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(
    const ProviderScope(
      child: PartyGameApp(),
    ),
  );
}

class PartyGameApp extends StatelessWidget {
  const PartyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Game Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9333EA),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Segoe UI',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ),
      home: const MainMenuScreen(),
    );
  }
}
