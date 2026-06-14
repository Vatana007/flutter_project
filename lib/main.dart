import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/screens/splash_screen.dart';
import 'package:project_flutter/screens/login_screen.dart';
import 'package:project_flutter/screens/notifications_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      appState: _appState,
      child: ListenableBuilder(
        listenable: _appState,
        builder: (context, child) {
          return MaterialApp(
            title: 'EduTrack Mobile',
            debugShowCheckedModeBanner: false,
            
            // Light Theme System
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              primaryColor: const Color(0xFF4F46E5),
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
              fontFamily: 'Outfit',
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF4F46E5),
                secondary: Color(0xFF10B981),
                surface: Color(0xFFF8FAFC),
                error: Colors.redAccent,
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Color(0xFF1E293B)),
                titleTextStyle: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
              ),
            ),
            
            // Dark Theme System
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF818CF8),
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              fontFamily: 'Outfit',
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF818CF8),
                secondary: Color(0xFF34D399),
                surface: Color(0xFF0F172A),
                error: Colors.redAccent,
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Color(0xFF0F172A),
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color(0xFF1E293B),
              ),
            ),
            
            // Manage Active Theme Mode dynamically
            themeMode: _appState.themeMode,
            
            // App Start Route
            home: SplashScreen(appState: _appState),
            
            // Named Routes configurations
            routes: {
              '/login': (context) => const LoginScreen(),
              '/notifications': (context) => NotificationsScreen(appState: _appState),
            },
          );
        },
      ),
    );
  }
}
