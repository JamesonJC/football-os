import 'package:flutter/material.dart';

import 'package:football_os/core/features/dashboard/dashboard_screen.dart';

void main() {
  runApp(const FootballOSApp());
}

class FootballOSApp extends StatelessWidget {
  const FootballOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          brightness: Brightness.dark,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}