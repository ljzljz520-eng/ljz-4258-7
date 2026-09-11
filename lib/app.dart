import 'package:flutter/material.dart';

import 'ui/home_page.dart';

class CheeseTraceApp extends StatelessWidget {
  const CheeseTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '奶酪制作追溯',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8D6E63)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
