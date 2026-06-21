import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_flutter/core/theme/app_theme.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/screens/splash_screen.dart';
import 'package:project_flutter/screens/login_screen.dart';
import 'package:project_flutter/screens/notifications_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState(widget.prefs);
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
            debugShowCheckedModeBanner: false, // delete button Debug
            
            // Light Theme System
            theme: AppTheme.lightTheme,
            
            // Dark Theme System
            darkTheme: AppTheme.darkTheme,
            
            // Manage Active Theme Mode dynamically
            themeMode: _appState.themeMode,
            
            // App Start Route
            home: const SplashScreen(),
            
            // Named Routes configurations
            routes: {
              '/login': (context) => const LoginScreen(),
              // '/notifications': (context) => const NotificationsScreen(),
            },
          );
        },
      ),
    );
  }
}
