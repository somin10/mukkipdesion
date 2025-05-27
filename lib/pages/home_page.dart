import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chat_list_page.dart';
import 'map_page.dart';
import 'my_muckip_page.dart';
import 'fridge_page.dart'; // 냉장고 페이지 (너가 나중에 추가할 수 있음)

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FridgePage(),
    MapPage(),
    ChatListPage(),
    MyMuckipPage(),
  ];

  final List<String> _activeIcons = [
    'assets/icons/type=active.svg',
    'assets/icons/type=active-1.svg',
    'assets/icons/type=active-2.svg',
    'assets/icons/type=active-3.svg',
  ];

  final List<String> _inactiveIcons = [
    'assets/icons/type=inactive.svg',
    'assets/icons/type=inactive-1.svg',
    'assets/icons/type=inactive-2.svg',
    'assets/icons/type=inactive-3.svg',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: List.generate(4, (index) {
          final isSelected = _selectedIndex == index;
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              isSelected ? _activeIcons[index] : _inactiveIcons[index],
              width: 55,
              height: 55,
            ),
            label: ' ',
          );
        }),
      ),
    );
  }
}
