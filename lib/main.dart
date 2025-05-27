import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // 💡 우리가 만든 HomePage를 불러옴

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jido',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomePage(), // ✅ 여기서 HomePage()로 진입!
    );
  }
}
