import 'package:flutter/material.dart';

class MyMuckipPage extends StatelessWidget {
  const MyMuckipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('나의 먹킵')),
      body: Center(child: Text('먹킵 페이지')),
    );
  }
}
