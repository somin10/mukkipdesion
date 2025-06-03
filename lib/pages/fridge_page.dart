import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

// 식재료 데이터 모델 추가
class FridgeItem {
  final String name;
  final int quantity;
  final DateTime expiryDate;

  FridgeItem({
    required this.name,
    required this.quantity,
    required this.expiryDate,
  });

  // 유통기한까지 남은 일수 계산
  int get daysUntilExpiry {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  // 유통기한 상태에 따른 색상 반환
  Color get statusColor {
    final days = daysUntilExpiry;
    if (days < 0) return Color(0xFFFF6640); // 만료됨
    if (days <= 3) return Color(0xFFFFDE00); // 임박
    if (days <= 7) return Color(0xFF89E219); // 괜찮음
    return Color(0xFF4BB200); // 여유있음
  }

  // 유통기한 상태에 따른 배경색 반환
  Color get badgeColor {
    final days = daysUntilExpiry;
    if (days < 0) return Color(0xFFFFE3DB); // 만료됨
    if (days <= 3) return Color(0xFFFFF7BF); // 임박
    if (days <= 7) return Color(0xFFE1FDD7); // 괜찮음
    return Color(0xFFCDFFC1); // 여유있음
  }

  // 유통기한 상태에 따른 태그 배경색 반환
  Color get tagColor {
    final days = daysUntilExpiry;
    if (days < 0) return Color(0xFFFFCCCC); // 만료됨
    if (days <= 3) return Color(0xFFFFEDED); // 임박
    if (days <= 7) return Color(0xFFD8FFCC); // 괜찮음
    return Color(0xFFB8FFA3); // 여유있음
  }

  // 유통기한 상태 텍스트 반환
  String get statusText {
    final days = daysUntilExpiry;
    if (days == -6) return '-6일';
    if (days == -2) return '-2일';
    if (days == 3) return '3일';
    if (days == 8) return '8일';
    if (days < 0) return '$days일';
    return '$days일';
  }
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
      body: SafeArea(
        child: Stack(
          children: [
            // 메인 콘텐츠
            Column(
              children: [
                // 헤더
                Container(
                  width: double.infinity,
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

                // 스크롤 가능한 본문 영역
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 유통기한 임박 알림 배너 (조건부 렌더링)
                        if (hasNearExpiry)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 20,
                              left: 20,
                              right: 20,
                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                        // 냉장고 영역
                        Container(
                          width: double.infinity,
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
                              Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children:
                                    fridgeList.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      Fridge fridge = entry.value;
                                      return FridgeCard(
                                        fridge: fridge,
                                        onFavorite:
                                            () => _toggleFavorite(index),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => FridgeDetailPage(
                                                    fridge: fridge,
                                                  ),
                                            ),
                                          );
                                        },
                                        onMore: () {
                                          _showMoreMenu(context, index);
                                        },
                                      );
                                    }).toList(),
                              ),

                              // 하단 여백 추가 (네비게이션 바를 위한 공간)
                              SizedBox(height: 70),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 상품 추가 버튼
            Positioned(
              right: 20,
              bottom: 80,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: 상품 추가 기능
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4BB200), Color(0xFF89E119)],
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(Icons.add, color: Colors.white, size: 24),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '상품추가',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
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

// 냉장고 상세 페이지
class FridgeDetailPage extends StatefulWidget {
  final Fridge fridge;

  const FridgeDetailPage({super.key, required this.fridge});

  @override
  State<FridgeDetailPage> createState() => _FridgeDetailPageState();
}

class _FridgeDetailPageState extends State<FridgeDetailPage> {
  List<FridgeItem> items = [];
  late String sortOption = '유통기한 임박순';
  int nearExpiryCount = 0;
  int expiredCount = 0;

  @override
  void initState() {
    super.initState();
    // 샘플 데이터 생성
    _loadSampleItems();
    _countItemStatus();
  }

  void _loadSampleItems() {
    // 샘플 데이터 (Figma와 일치하는 데이터)
    items = [
      FridgeItem(
        name: '저당 딸기잼 320g',
        quantity: 1,
        expiryDate: DateTime.now().subtract(Duration(days: 6)),
      ),
      FridgeItem(
        name: '깨수깡환 3g (1포)',
        quantity: 6,
        expiryDate: DateTime.now().subtract(Duration(days: 2)),
      ),
      FridgeItem(
        name: '초코에몽',
        quantity: 5,
        expiryDate: DateTime.now().add(Duration(days: 3)),
      ),
      FridgeItem(
        name: '완두콩 400g',
        quantity: 2,
        expiryDate: DateTime.now().add(Duration(days: 8)),
      ),
    ];

    // 정렬
    _sortItems();
  }

  void _countItemStatus() {
    nearExpiryCount =
        items
            .where(
              (item) => item.daysUntilExpiry >= 0 && item.daysUntilExpiry <= 3,
            )
            .length;
    expiredCount = items.where((item) => item.daysUntilExpiry < 0).length;
  }

  void _sortItems() {
    if (sortOption == '유통기한 임박순') {
      items.sort((a, b) => a.daysUntilExpiry.compareTo(b.daysUntilExpiry));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 냉장고 헤더 (Figma 디자인에 맞게 수정)
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 뒤로가기 버튼
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          '←',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF111111),
                          ),
                        ),
                      ),

                      // 냉장고 이름
                      Row(
                        children: [
                          Text(
                            widget.fridge.name,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Color(0xFF4BB200),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF4BB200),
                          ),
                        ],
                      ),

                      // 사용자 추가 버튼 및 메뉴
                      Row(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Color(0xFF323232),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.menu, color: Color(0xFF111111), size: 16),
                        ],
                      ),
                    ],
                  ),
                ),

                // 메인 컨텐츠
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 상단 상태 카드 영역
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // 유통기한 임박 상품
                              Expanded(
                                child: Container(
                                  height: 41,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xFFE6E6E6),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '유통기한 임박상품',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                      Text(
                                        '$nearExpiryCount',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFF4BB200),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              // 유통기한 만료상품
                              Expanded(
                                child: Container(
                                  height: 41,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xFFE6E6E6),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '유통기한 만료상품',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                      Text(
                                        '$expiredCount',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFFFF6640),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 정렬 옵션 & 필터
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 상품 수
                              Row(
                                children: [
                                  Text(
                                    '상품',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${items.length}',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xFF4BB200),
                                    ),
                                  ),
                                ],
                              ),

                              // 정렬 옵션
                              Row(
                                children: [
                                  Text(
                                    sortOption,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF4BB200),
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        // 식재료 리스트 (Figma 디자인에 맞게 수정)
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final formattedDate = DateFormat(
                              'yy.MM.dd',
                            ).format(item.expiryDate);

                            // Figma 디자인에 맞는 배경 이미지 가져오기
                            String bgImagePath = '';
                            if (item.daysUntilExpiry < 0) {
                              bgImagePath = 'assets/images/pink_bg.png';
                            } else if (item.daysUntilExpiry <= 3) {
                              bgImagePath = 'assets/images/yellow_bg.png';
                            } else if (item.daysUntilExpiry <= 7) {
                              bgImagePath = 'assets/images/green_bg.png';
                            } else {
                              bgImagePath = 'assets/images/light_green_bg.png';
                            }

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: 120,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // 상품 정보
                                  Positioned(
                                    left: 20,
                                    top: 20,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // 상품명
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 10),

                                        // 수량 조절 영역 - Figma 디자인에 맞게 이름 오른쪽으로 이동
                                        Row(
                                          children: [
                                            // 감소 버튼
                                            Container(
                                              width: 17,
                                              height: 17,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(0xFFD9D9D9),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            // 현재 수량
                                            Text(
                                              '${item.quantity}',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            // 증가 버튼
                                            Container(
                                              width: 17,
                                              height: 17,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(0xFFD9D9D9),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 유통기한 정보
                                  Positioned(
                                    left: 20,
                                    bottom: 10,
                                    child: Row(
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFF808080),
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          '까지',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFF808080),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 유통기한 상태 표시 바 컨테이너
                                  Positioned(
                                    left: 20,
                                    right: 20 + 80 + 20,
                                    bottom: 35,
                                    child: Container(
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 1,
                                            offset: Offset(0, 0),
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          // 상태 게이지 (Figma 디자인에 맞게 수정)
                                          Container(
                                            width: _getProgressWidthFigma(
                                              item.daysUntilExpiry,
                                            ),
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: item.statusColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  blurRadius: 5,
                                                  offset: Offset(0, 5),
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // 중간점
                                          Positioned(
                                            left: (232.0 / 2.0) - (5.0 / 2.0),
                                            child: Container(
                                              width: 5,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),

                                          // 남은 일수 뱃지를 그래프 바 안에 배치
                                          Positioned(
                                            left:
                                                _getBadgeLeftFigma(
                                                  item.daysUntilExpiry,
                                                ) -
                                                20, // 왼쪽 패딩 보정
                                            top: -22, // 그래프 바 위에 위치
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: item.badgeColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 3,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                item.statusText,
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // 상품 이미지 영역 (더 명확하게 보이도록 스타일 수정)
                                  Positioned(
                                    right: 20,
                                    top: 20,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: AssetImage(bgImagePath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // 하단 여백 추가 (FAB를 위한 공간)
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 상품 추가 버튼 (Figma 디자인에 맞게 수정)
            Positioned(
              right: 20,
              bottom: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: 상품 추가 기능
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4BB200), Color(0xFF89E119)],
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(Icons.add, color: Colors.white, size: 24),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '상품추가',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
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

  // Figma 디자인 기반으로 수정된 상태 게이지 너비 계산
  double _getProgressWidthFigma(int days) {
    // Figma 디자인 값 기준 (전체 너비 232px)
    double totalWidth = 232.0;

    // 특정 일수에 따른 너비 지정 (Figma에서 직접 측정한 값 기준)
    if (days <= -10) return totalWidth * 0.05; // 최소 너비 (5%)
    if (days >= 14) return totalWidth * 0.95; // 최대 너비 (95%)

    // Figma에서 직접 측정한 특정 일수에 대한 너비값
    if (days == -6) return 38.0; // Figma 디자인에서 측정한 -6일 위치
    if (days == -2) return 77.0; // Figma 디자인에서 측정한 -2일 위치
    if (days == 3) return 125.7; // Figma 디자인에서 측정한 3일 위치
    if (days == 8) return 174.5; // Figma 디자인에서 측정한 8일 위치

    // 중간값은 선형 보간법 사용
    if (days < -6) {
      // -10일 ~ -6일 사이
      double ratio = (days + 10.0) / 4.0;
      return 38.0 * ratio;
    } else if (days < -2) {
      // -6일 ~ -2일 사이
      double ratio = (days + 6.0) / 4.0;
      return 38.0 + (77.0 - 38.0) * ratio;
    } else if (days < 3) {
      // -2일 ~ 3일 사이
      double ratio = (days + 2.0) / 5.0;
      return 77.0 + (125.7 - 77.0) * ratio;
    } else if (days < 8) {
      // 3일 ~ 8일 사이
      double ratio = (days - 3.0) / 5.0;
      return 125.7 + (174.5 - 125.7) * ratio;
    } else {
      // 8일 ~ 14일 사이
      double ratio = (days - 8.0) / 6.0;
      return 174.5 + (totalWidth * 0.95 - 174.5) * ratio;
    }
  }

  // Figma 디자인 기반으로 수정된 일수 뱃지 위치 계산
  double _getBadgeLeftFigma(int days) {
    // 그래프 시작 위치와 너비 가져오기
    double graphStartX = 0.0; // 그래프 시작 X 좌표 (컨테이너 내부 기준)
    double badgeWidth = 38.0; // 뱃지 너비 (Figma 기반)

    // 특정 일수에 대한 위치 (Figma에서 직접 측정)
    if (days == -6) return graphStartX + 38.0 - badgeWidth / 2;
    if (days == -2) return graphStartX + 77.0 - badgeWidth / 2;
    if (days == 3) return graphStartX + 125.7 - badgeWidth / 2;
    if (days == 8) return graphStartX + 174.5 - badgeWidth / 2;

    // 다른 일수에 대해서는 그래프 진행도에 맞춰 위치 계산
    double progressWidth = _getProgressWidthFigma(days);
    double badgePosition = graphStartX + progressWidth - (badgeWidth / 2);

    // 뱃지가 화면을 벗어나지 않도록 조정
    double graphContainerWidth = 232.0;
    return badgePosition.clamp(
      graphStartX,
      graphStartX + graphContainerWidth - badgeWidth,
    );
  }
}
