import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Fridge {
  final String name;
  final int itemCount;
  final int nearExpiry;

  Fridge({
    required this.name,
    required this.itemCount,
    required this.nearExpiry,
  });
}

// ✅ 냉장고 탭 페이지
class FridgePage extends StatefulWidget {
  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  List<Fridge> fridgeList = [
    Fridge(name: '우리집 냉장고', itemCount: 6, nearExpiry: 2),
    Fridge(name: '할머니집 냉장고', itemCount: 3, nearExpiry: 1),
  ];

  void _addFridge(String name) {
    setState(() {
      fridgeList.add(Fridge(name: name, itemCount: 0, nearExpiry: 0));
    });
  }

  void _showAddDialog() {
    String fridgeName = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('새 냉장고 만들기'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: '냉장고 이름 입력'),
          onChanged: (value) => fridgeName = value,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
          TextButton(
            onPressed: () {
              if (fridgeName.trim().isNotEmpty) {
                _addFridge(fridgeName);
              }
              Navigator.pop(context);
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 냉장고'),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/plus.svg', width: 24),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '내가 참여중인 냉장고',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: fridgeList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final fridge = fridgeList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FridgeDetailPage(fridge: fridge),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fridge.name,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(
                                '유통기한 임박 ${fridge.nearExpiry}개',
                                style: TextStyle(color: Colors.red, fontSize: 13),
                              ),
                              Text(
                                '식재료 ${fridge.itemCount}개',
                                style:
                                TextStyle(color: Colors.grey[800], fontSize: 13),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/star_off.svg',
                                    width: 24,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/dots.svg',
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              'assets/icons/dots.svg',
                              width: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ 냉장고 상세 페이지 (더미)
class FridgeDetailPage extends StatelessWidget {
  final Fridge fridge;

  const FridgeDetailPage({required this.fridge});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fridge.name)),
      body: Center(
        child: Text('여기에 ${fridge.name} 안에 들어있는 식재료 리스트를 보여줄 수 있음'),
      ),
    );
  }
}
