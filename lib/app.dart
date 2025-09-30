import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

class ManagerApp extends StatelessWidget {
  const ManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: 'SF Pro',
      scaffoldBackgroundColor: const Color(0xFFF5F6F7),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3DDC84), // зелёный как в макете
        brightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Manager',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}
