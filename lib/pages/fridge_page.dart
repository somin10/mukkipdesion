import 'package:flutter/material.dart';

// 냉장고 데이터 모델
class Fridge {
  final String name;
  final int itemCount;
  final int nearExpiry;
  bool isFavorite;
  Color color;

  Fridge({
    required this.name,
    required this.itemCount,
    required this.nearExpiry,
    this.isFavorite = false,
    this.color = const Color(0xFFF3F4F6),
  });
}

// 나의 냉장고 페이지 (피그마 디자인 기반)
class FridgePage extends StatefulWidget {
  const FridgePage({super.key});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  List<Fridge> fridgeList = [
    Fridge(name: '집 냉장고', itemCount: 12, nearExpiry: 3, isFavorite: true),
    Fridge(
      name: '간석역 BHC 고기 냉장창고',
      itemCount: 37,
      nearExpiry: 3,
      isFavorite: true,
    ),
    Fridge(name: '부모님집 냉장고', itemCount: 23, nearExpiry: 0, isFavorite: false),
  ];

  @override
  void initState() {
    super.initState();
    _sortFridges();
  }

  void _toggleFavorite(int index) {
    setState(() {
      fridgeList[index].isFavorite = !fridgeList[index].isFavorite;
      _sortFridges();
    });
  }

  void _sortFridges() {
    fridgeList.sort((a, b) {
      // 1. 즐겨찾기 우선
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      // 2. 이름 가나다순
      return a.name.compareTo(b.name);
    });
  }

  void _showAddDialog() {
    String fridgeName = '';
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('새 냉장고 만들기'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: '냉장고 이름 입력'),
              onChanged: (value) => fridgeName = value,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  if (fridgeName.trim().isNotEmpty) {
                    setState(() {
                      fridgeList.add(
                        Fridge(name: fridgeName, itemCount: 0, nearExpiry: 0),
                      );
                      _sortFridges();
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          ),
    );
  }

  void _showMoreMenu(BuildContext context, int index) {
    final fridge = fridgeList[index];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단 핸들
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 메뉴 아이템들
              ListTile(
                leading: Icon(Icons.settings, color: Color(0xFF111111)),
                title: Text(
                  '냉장고 관리',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  print('냉장고 관리: ${fridge.name}');
                  // TODO: 냉장고 관리 페이지로 이동
                },
              ),

              ListTile(
                leading: Icon(Icons.color_lens, color: Color(0xFF111111)),
                title: Text(
                  '색상 설정',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showColorDialog(index);
                },
              ),

              ListTile(
                leading: Icon(Icons.delete_outline, color: Color(0xFFFF3B30)),
                title: Text(
                  '삭제하기',
                  style: TextStyle(
                    color: Color(0xFFFF3B30),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(int index) {
    final fridge = fridgeList[index];

    showDialog(
      context: context,
      barrierColor: Color(0x80000000), // 50% 투명도의 검정색 배경
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 352,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 26),
                  Column(
                    children: [
                      Text(
                        '정말로 삭제하시겠습니까?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFF6640),
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.85),
                      Text(
                        '삭제한 냉장고는 복원할 수 없습니다!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height:
                              1.71, // line height: 24px / font size: 14px = 1.71
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      // 취소하기 버튼
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFE6E6E6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                '취소하기',
                                style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // 삭제하기 버튼
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              fridgeList.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6640),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                '삭제하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showColorDialog(int index) {
    final fridge = fridgeList[index];
    // 임시 선택 색상을 저장할 변수
    Color selectedColor = fridge.color;

    final List<Color> colorOptions = [
      Color(0xFFF3F4F6), // 기본 회색
      Color(0xFFFFD8D8), // 연한 빨강
      Color(0xFFFFDFAA), // 연한 주황
      Color(0xFFFCFF97), // 연한 노랑
      Color(0xFFB3FFA1), // 연한 녹색
      Color(0xFFC8FF82), // 연한 라임
      Color(0xFFCAF7FF), // 연한 파랑
      Color(0xFFC8CFFF), // 연한 보라
      Color(0xFFF2DBFF), // 연한 자주
      Color(0xFFFFD7F0), // 연한 분홍
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Center(
                    child: Text(
                      '냉장고의 색상을 선택해주세요',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 20,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // 색상 옵션 그리드
                  Center(
                    child: Wrap(
                      spacing: 17,
                      runSpacing: 17,
                      children:
                          colorOptions.map((color) {
                            final isSelected = selectedColor == color;
                            return GestureDetector(
                              onTap: () {
                                // 색상 선택만 임시 저장 (아직 적용하지 않음)
                                setModalState(() {
                                  selectedColor = color;
                                });
                              },
                              child: Container(
                                width: 37,
                                height: 37,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFFD9D9D9),
                                    width: 1,
                                  ),
                                ),
                                child:
                                    isSelected
                                        ? Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Color(0xFF323232),
                                            size: 16,
                                          ),
                                        )
                                        : null,
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  SizedBox(height: 30),

                  // 확인 버튼
                  InkWell(
                    onTap: () {
                      // 확인 버튼 클릭 시에만 색상 적용
                      setState(() {
                        fridgeList[index].color = selectedColor;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF4BB200),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 유통기한 임박 식재료가 하나라도 있는지 확인
    final hasNearExpiry = fridgeList.any((f) => f.nearExpiry > 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: 412,
        height: 917,
        child: Stack(
          children: [
            // 상태바
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 412,
                height: 48.07,
                color: Colors.transparent,
              ),
            ),

            // 헤더
            Positioned(
              left: 0,
              top: 48.07,
              child: Container(
                width: 412,
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '나의 냉장고',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 20,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showAddDialog,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14.59,
                            height: 14.59,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF111111),
                                width: 0.8,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 10,
                                color: Color(0xFF111111),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '냉장고 만들기',
                            style: TextStyle(
                              color: Color(0xFF111111),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 유통기한 임박 알림 배너 (조건부 렌더링)
            if (hasNearExpiry)
              Positioned(
                left: 20,
                top: 124.07,
                child: Container(
                  width: 372,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // 달력 아이콘
                      Container(
                        width: 44.86,
                        height: 29.19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          color: Color(0xFF78F200),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 17),
                      // 텍스트 영역
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '유통기간이 임박한 식재료가 있어요!',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '바로 확인하기 ->',
                              style: TextStyle(
                                color: Color(0xFF4BB200),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 닫기 버튼
                      SizedBox(
                        width: 13.18,
                        height: 13.18,
                        child: Icon(
                          Icons.close,
                          color: Color(0xFFAFB6C0),
                          size: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 메인 콘텐츠 영역
            Positioned(
              left: 0,
              top: hasNearExpiry ? 214.07 : 124.07, // 알림 배너 유무에 따라 위치 조정
              child: Container(
                width: 412,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 섹션 타이틀
                    Text(
                      '내가 참여중인 냉장고',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    // 냉장고 카드 그리드
                    SizedBox(
                      width: 372,
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children:
                            fridgeList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Fridge fridge = entry.value;
                              return FridgeCard(
                                fridge: fridge,
                                onFavorite: () => _toggleFavorite(index),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              FridgeDetailPage(fridge: fridge),
                                    ),
                                  );
                                },
                                onMore: () {
                                  _showMoreMenu(context, index);
                                },
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 하단 네비게이션 바
            Positioned(
              left: 0,
              top: 833,
              child: Container(
                width: 412,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 4,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _NavItem(label: '나의 냉장고', isActive: true),
                    _NavItem(label: '나눔 지도', isActive: false),
                    _NavItem(label: '채팅', isActive: false),
                    _NavItem(label: '나의 먹킵', isActive: false),
                  ],
                ),
              ),
            ),

            // 하단 핸들
            Positioned(
              left: 0,
              top: 893,
              child: Container(
                width: 412,
                height: 24,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: 108,
                    height: 4,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1B20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 냉장고 카드 위젯
class FridgeCard extends StatelessWidget {
  final Fridge fridge;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final VoidCallback onMore;

  const FridgeCard({
    super.key,
    required this.fridge,
    required this.onFavorite,
    required this.onTap,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 176,
        height: 150,
        decoration: BoxDecoration(
          color: fridge.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // 냉장고 정보
            Positioned(
              left: 20,
              top: 18.90,
              child: SizedBox(
                width: 113.03,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fridge.name,
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3),
                    // 유통기한 임박 식재료 수 표시 (조건부)
                    if (fridge.nearExpiry > 0)
                      Text(
                        '유통기한 임박 ${fridge.nearExpiry}개',
                        style: TextStyle(
                          color: Color(0xFFFF6640),
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    if (fridge.nearExpiry > 0) SizedBox(height: 2),
                    Text(
                      '식재료 ${fridge.itemCount}개',
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 즐겨찾기 버튼
            Positioned(
              left: 15,
              top: 105,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onFavorite,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        fridge.isFavorite ? Icons.star : Icons.star_border,
                        color:
                            fridge.isFavorite
                                ? Color(0xFFFFDE00)
                                : Color(0xFFB2B2B2),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 더보기 버튼
            Positioned(
              left: 142,
              top: 10,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onMore,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: SizedBox(
                        width: 4,
                        height: 16,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFF5A5A5A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFF5A5A5A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFF5A5A5A),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 네비게이션 아이템
class _NavItem extends StatelessWidget {
  final String label;
  final bool isActive;

  const _NavItem({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 103,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            // TODO: 실제 아이콘으로 교체
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Color(0xFF4BB200) : Color(0xFFA2A5AA),
              fontSize: 11,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 0.91,
            ),
          ),
        ],
      ),
    );
  }
}

// 냉장고 상세 페이지
class FridgeDetailPage extends StatelessWidget {
  final Fridge fridge;

  const FridgeDetailPage({super.key, required this.fridge});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(fridge.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          '${fridge.name}\n식재료 ${fridge.itemCount}개',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontFamily: 'Pretendard'),
        ),
      ),
    );
  }
}
