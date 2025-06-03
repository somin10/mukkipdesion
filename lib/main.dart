import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import './providers/food_provider.dart';
import 'pages/home_page.dart'; // 💡 우리가 만든 HomePage를 불러옴

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 웹 환경이 아닌 경우에만 네이버 지도 초기화
  if (!kIsWeb) {
    try {
      print('네이버 맵 SDK 초기화 시작');
      // 네이버 맵 초기화
      await NaverMapSdk.instance.initialize(
        clientId: '1uae9g33a6',
        onAuthFailed: (error) {
          print('네이버 맵 인증 실패: $error');
        },
      );
      print('네이버 맵 SDK 초기화 성공');
    } catch (e) {
      print('네이버 맵 SDK 초기화 오류: $e');
    }
  } else {
    print('웹 환경에서는 네이버 맵 SDK 초기화를 건너뜁니다.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FoodProvider())],
      child: MaterialApp(
        title: 'Jido',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: HomePage(), // ✅ 여기서 HomePage()로 진입!
      ),
    );
  }
}
