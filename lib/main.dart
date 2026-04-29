// lib/main.dart
// ─────────────────────────────────────────────────────────────────────────────
// QuickCook – Where Time Meets Taste
// Entry point: sets up Firebase + MultiProvider and starts at Splash.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// 🔥 Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// 🌱 ENV
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/recipe_provider.dart';

// UI
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌱 LOAD ENV VARIABLES (MUST BE BEFORE FIREBASE)
  await dotenv.load(fileName: ".env");

  // 🔍 DEBUG (remove later)
  print("FIREBASE_API_KEY: ${dotenv.env['FIREBASE_API_KEY']}");

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // 🔥 IMPORTANT: init() must be called
        ChangeNotifierProvider(
          create: (_) => RecipeProvider()..init(),
        ),
      ],
      child: const QuickCookApp(),
    ),
  );
}

class QuickCookApp extends StatelessWidget {
  const QuickCookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'QuickCook',
      debugShowCheckedModeBanner: false,
      themeMode: themeProv.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // Splash → will redirect to AuthWrapper
      home: const SplashScreen(),
    );
  }
}