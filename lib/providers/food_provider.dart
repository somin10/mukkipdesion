import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import '../models/food_item.dart';

class FoodProvider extends ChangeNotifier {
  List<FoodItem> _foodItems = [];
  List<FoodItem> _filteredFoodItems = [];
  Set<FoodCategory> _selectedCategories = {};
  String _searchQuery = '';
  bool _isShareMode = true;
  LocationData? _currentPosition;

  // Getters
  List<FoodItem> get foodItems => _foodItems;
  List<FoodItem> get filteredFoodItems => _filteredFoodItems;
  Set<FoodCategory> get selectedCategories => _selectedCategories;
  String get searchQuery => _searchQuery;
  bool get isShareMode => _isShareMode;
  LocationData? get currentPosition => _currentPosition;

  // 긴급한 아이템만 필터링
  List<FoodItem> get urgentFoodItems {
    return _filteredFoodItems.where((item) => item.isUrgent).toList();
  }

  // 초기 더미 데이터 설정
  void initializeMockData() {
    _foodItems = [
      FoodItem(
        id: '1',
        name: '앙팡 우유 2개',
        description: '유통기한이 내일까지인 우유입니다',
        category: FoodCategory.dairy,
        freshness: FoodFreshness.urgent,
        latitude: 37.5651,
        longitude: 126.9767,
        ownerId: 'user1',
        ownerName: '김나눔',
        ownerImageUrl: 'https://example.com/user1.jpg',
        foodMannerScore: 4.8,
        walkingMinutes: 9,
        isUrgent: true,
        imageUrl: 'https://example.com/milk.jpg',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      FoodItem(
        id: '2',
        name: '오렌지 1박스',
        description: '신선한 오렌지 1박스 나눔합니다',
        category: FoodCategory.fruits,
        freshness: FoodFreshness.good,
        latitude: 37.5671,
        longitude: 126.9798,
        ownerId: 'user2',
        ownerName: '엄준식',
        ownerImageUrl: 'https://example.com/user2.jpg',
        foodMannerScore: 4.4,
        walkingMinutes: 6,
        isUrgent: false,
        imageUrl: 'https://example.com/orange.jpg',
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
      ),
      FoodItem(
        id: '3',
        name: '양파 10개',
        description: '많이 사서 나눔합니다',
        category: FoodCategory.vegetables,
        freshness: FoodFreshness.fresh,
        latitude: 37.5645,
        longitude: 126.9751,
        ownerId: 'user3',
        ownerName: '김나눔',
        ownerImageUrl: 'https://example.com/user3.jpg',
        foodMannerScore: 4.8,
        walkingMinutes: 6,
        isUrgent: false,
        imageUrl: 'https://example.com/onion.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      FoodItem(
        id: '4',
        name: '부침가루 500g',
        description: '아직 쌩쌩해요',
        category: FoodCategory.grains,
        freshness: FoodFreshness.fresh,
        latitude: 37.5632,
        longitude: 126.9769,
        ownerId: 'user4',
        ownerName: '이웃님',
        ownerImageUrl: 'https://example.com/user4.jpg',
        foodMannerScore: 4.5,
        walkingMinutes: 5,
        isUrgent: false,
        imageUrl: 'https://example.com/flour.jpg',
        createdAt: DateTime.now().subtract(Duration(hours: 8)),
      ),
      FoodItem(
        id: '5',
        name: '소고기 300g',
        description: '오늘 받은 선물인데 혼자 먹기 많아요',
        category: FoodCategory.meat,
        freshness: FoodFreshness.urgent,
        latitude: 37.5689,
        longitude: 126.9812,
        ownerId: 'user5',
        ownerName: '박정성',
        ownerImageUrl: 'https://example.com/user5.jpg',
        foodMannerScore: 4.9,
        walkingMinutes: 12,
        isUrgent: true,
        imageUrl: 'https://example.com/beef.jpg',
        createdAt: DateTime.now().subtract(Duration(hours: 1)),
      ),
      FoodItem(
        id: '6',
        name: '바나나 1송이',
        description: '잘 익은 바나나입니다',
        category: FoodCategory.fruits,
        freshness: FoodFreshness.fair,
        latitude: 37.5701,
        longitude: 126.9734,
        ownerId: 'user6',
        ownerName: '최친절',
        ownerImageUrl: 'https://example.com/user6.jpg',
        foodMannerScore: 4.7,
        walkingMinutes: 15,
        isUrgent: false,
        imageUrl: 'https://example.com/banana.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      FoodItem(
        id: '7',
        name: '요거트 6개',
        description: '유통기한 3일 남았어요',
        category: FoodCategory.dairy,
        freshness: FoodFreshness.good,
        latitude: 37.5622,
        longitude: 126.9745,
        ownerId: 'user7',
        ownerName: '김유제품',
        ownerImageUrl: 'https://example.com/user7.jpg',
        foodMannerScore: 4.6,
        walkingMinutes: 8,
        isUrgent: false,
        imageUrl: 'https://example.com/yogurt.jpg',
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
      ),
    ];
    _filteredFoodItems = List.from(_foodItems);
    notifyListeners();
  }

  // 카테고리 필터 토글
  void toggleCategory(FoodCategory category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _applyFilters();
  }

  // 전체 카테고리 선택/해제
  void toggleAllCategories() {
    if (_selectedCategories.length == FoodCategory.values.length - 1) {
      _selectedCategories.clear();
    } else {
      _selectedCategories = Set.from(
        FoodCategory.values.where((c) => c != FoodCategory.urgent),
      );
    }
    _applyFilters();
  }

  // 검색어 업데이트
  void searchFoodItems(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // 필터 적용
  void _applyFilters() {
    _filteredFoodItems =
        _foodItems.where((item) {
          // 카테고리 필터
          if (_selectedCategories.isNotEmpty &&
              !_selectedCategories.contains(item.category)) {
            return false;
          }

          // 검색어 필터
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            return item.name.toLowerCase().contains(query) ||
                item.description.toLowerCase().contains(query) ||
                item.ownerName.toLowerCase().contains(query);
          }

          return true;
        }).toList();

    notifyListeners();
  }

  // 모드 전환 (나눔/요청)
  void toggleMode() {
    _isShareMode = !_isShareMode;
    notifyListeners();
  }

  // 현재 위치 가져오기
  Future<void> getCurrentLocation() async {
    print('위치 정보 요청 시작');
    final location = Location();

    try {
      // 권한 확인
      bool serviceEnabled = await location.serviceEnabled();
      print('위치 서비스 활성화 상태: $serviceEnabled');
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        print('위치 서비스 요청 결과: $serviceEnabled');
        if (!serviceEnabled) {
          print('위치 서비스 비활성화 - 기본 위치 사용');
          _setDefaultLocation();
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      print('위치 권한 상태: $permissionGranted');
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        print('위치 권한 요청 결과: $permissionGranted');
        if (permissionGranted != PermissionStatus.granted) {
          print('위치 권한 거부 - 기본 위치 사용');
          _setDefaultLocation();
          return;
        }
      }

      // 위치 가져오기
      print('위치 정보 가져오기 시도');
      _currentPosition = await location.getLocation();
      print(
        '위치 정보 획득: 위도 ${_currentPosition?.latitude}, 경도 ${_currentPosition?.longitude}',
      );
      notifyListeners();
    } catch (e) {
      print('위치 가져오기 실패: $e');
      _setDefaultLocation();
    }
  }

  // 기본 위치 설정 (서울시청)
  void _setDefaultLocation() {
    _currentPosition = LocationData.fromMap({
      "latitude": 37.5665,
      "longitude": 126.9780,
      "accuracy": 0.0,
      "altitude": 0.0,
      "speed": 0.0,
      "speed_accuracy": 0.0,
      "heading": 0.0,
      "time": 0.0,
    });
    notifyListeners();
    print('기본 위치로 설정됨: 서울시청');
  }

  // 아이템 추가
  void addFoodItem(FoodItem item) {
    _foodItems.add(item);
    _applyFilters();
  }

  // 아이템 삭제
  void removeFoodItem(String itemId) {
    _foodItems.removeWhere((item) => item.id == itemId);
    _applyFilters();
  }

  // 아이템 업데이트
  void updateFoodItem(FoodItem updatedItem) {
    final index = _foodItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _foodItems[index] = updatedItem;
      _applyFilters();
    }
  }
}
