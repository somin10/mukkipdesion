import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/food_item.dart';
import '../providers/food_provider.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/food_item_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  NaverMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final PanelController _panelController = PanelController();
  FoodItem? _selectedItem;
  bool _isMapReady = false;

  // 서울시청 기본 위치
  static const NLatLng _seoulCityHall = NLatLng(37.5665, 126.9780);

  // 마커 관리
  final Set<NMarker> _markers = {};

  // 기본 마커
  void _addDefaultMarker() {
    try {
      if (_mapController == null) return;

      final defaultMarker = NMarker(
        id: 'default_marker',
        position: _seoulCityHall,
        caption: NOverlayCaption(
          text: '서울시청',
          textSize: 14,
          color: Colors.black,
        ),
      );

      _mapController!.addOverlay(defaultMarker);
      print('기본 마커 추가 완료');
    } catch (e) {
      print('기본 마커 추가 실패: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final foodProvider = Provider.of<FoodProvider>(context, listen: false);
      print('초기화 시작: ${DateTime.now()}');
      foodProvider.initializeMockData();
      print('위치 정보 가져오기 시작: ${DateTime.now()}');
      foodProvider
          .getCurrentLocation()
          .then((_) {
            print('위치 정보 가져오기 완료: ${DateTime.now()}');
            if (_isMapReady) {
              _updateMarkers();
            }
          })
          .catchError((error) {
            print('위치 정보 가져오기 오류: $error');
            if (_isMapReady) {
              _updateMarkers();
            }
          });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _updateMarkers() async {
    print('마커 업데이트 시작: ${DateTime.now()}');
    if (kIsWeb || _mapController == null) {
      print('웹 환경이거나 맵 컨트롤러가 없어 마커 업데이트 실패');
      return;
    }

    try {
      final foodProvider = Provider.of<FoodProvider>(context, listen: false);
      final items = foodProvider.filteredFoodItems;
      print('업데이트할 아이템 수: ${items.length}');

      // 기존 마커 제거
      if (_markers.isNotEmpty) {
        print('기존 마커 제거: ${_markers.length}개');
        _mapController!.clearOverlays();
        _markers.clear();
      }

      // 빈 화면을 방지하기 위해 기본 마커 추가
      _addDefaultMarker();

      // 새 마커 생성
      if (items.isEmpty) {
        print('표시할 식재료 아이템이 없습니다.');
        return;
      }

      for (var item in items) {
        try {
          final marker = NMarker(
            id: 'marker_${item.id}',
            position: NLatLng(item.latitude, item.longitude),
            size: const Size(30, 40),
            caption: NOverlayCaption(
              text: item.name,
              textSize: 12,
              color: item.isUrgent ? Colors.red : Colors.black,
            ),
          );

          // 마커 탭 리스너 설정 (1.0.2 버전에서는 다른 방식 사용)
          marker.setOnTapListener((marker) {
            print('마커 탭: ${item.name}');
            _onMarkerTapped(item);
          });

          _markers.add(marker);
          _mapController!.addOverlay(marker);
        } catch (e) {
          print('마커 생성 중 오류: ${item.id} - $e');
        }
      }

      print('마커 업데이트 완료: ${_markers.length}개 추가됨');
    } catch (e) {
      print('마커 업데이트 전체 오류: $e');
    }
  }

  void _onMarkerTapped(FoodItem item) {
    setState(() {
      _selectedItem = item;
    });
    _showItemDetailBottomSheet(item);
  }

  void _showItemDetailBottomSheet(FoodItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: Icon(Icons.food_bank, color: Colors.grey[400]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.freshness.displayName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '걸어서 ${item.walkingMinutes}분',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: 상세보기 페이지로 이동
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '상세보기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FoodProvider>(
        builder: (context, foodProvider, child) {
          return SlidingUpPanel(
            controller: _panelController,
            minHeight: 200,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            panel: _buildBottomPanel(foodProvider),
            body: _buildMapBody(foodProvider),
          );
        },
      ),
    );
  }

  Widget _buildMapBody(FoodProvider foodProvider) {
    print('지도 빌드 시작: ${DateTime.now()}');
    return Stack(
      children: [
        // 웹에서는 네이버 지도 대신 대체 UI 표시
        if (kIsWeb)
          _buildWebMapPlaceholder(foodProvider)
        else
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target:
                    foodProvider.currentPosition != null
                        ? NLatLng(
                          foodProvider.currentPosition!.latitude ??
                              _seoulCityHall.latitude,
                          foodProvider.currentPosition!.longitude ??
                              _seoulCityHall.longitude,
                        )
                        : _seoulCityHall,
                zoom: 14,
              ),
              mapType: NMapType.basic,
              activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
              locationButtonEnable: true, // 위치 버튼 활성화
              consumeSymbolTapEvents: false,
            ),
            onMapReady: (controller) {
              print('지도 준비 완료: ${DateTime.now()}');
              setState(() {
                _mapController = controller;
                _isMapReady = true;
              });

              // 기본 마커 추가
              _addDefaultMarker();

              // 지도가 준비되면 마커 업데이트
              _updateMarkers();
            },
            onMapTapped: (point, latLng) {
              print('지도 탭 이벤트: $latLng');
            },
            onCameraChange: (reason, animated) {
              print('카메라 이동: $reason, animated: $animated');
            },
            onCameraIdle: () {
              print('카메라 이동 완료');
            },
          ),

        // Top overlay with search and filters
        SafeArea(
          child: Column(
            children: [
              // Search bar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '주변 식재료 검색',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                        onChanged: (value) {
                          foodProvider.searchFoodItems(value);
                          _updateMarkers();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Category filter chips
              CategoryFilterChips(onFilterChanged: _updateMarkers),
            ],
          ),
        ),

        // My location button
        Positioned(
          right: 16,
          bottom: 220,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            onPressed: () async {
              await foodProvider.getCurrentLocation();
              if (_mapController != null &&
                  foodProvider.currentPosition != null) {
                _mapController!.updateCamera(
                  NCameraUpdate.withParams(
                    target: NLatLng(
                      foodProvider.currentPosition!.latitude ??
                          _seoulCityHall.latitude,
                      foodProvider.currentPosition!.longitude ??
                          _seoulCityHall.longitude,
                    ),
                  ),
                );
              }
            },
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  // 웹용 지도 대체 UI
  Widget _buildWebMapPlaceholder(FoodProvider foodProvider) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              '웹 환경에서는 지도가 지원되지 않습니다.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '모바일 앱에서 실행해주세요.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 웹에서도 UI 테스트를 위해 마커 업데이트 및 화면 갱신
                setState(() {
                  _isMapReady = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'UI 테스트하기',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel(FoodProvider foodProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with toggle and share button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Mode toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!foodProvider.isShareMode) {
                            foodProvider.toggleMode();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                foodProvider.isShareMode
                                    ? const Color(0xFF4CAF50)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '나눔',
                            style: TextStyle(
                              color:
                                  foodProvider.isShareMode
                                      ? Colors.white
                                      : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (foodProvider.isShareMode) {
                            foodProvider.toggleMode();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                !foodProvider.isShareMode
                                    ? const Color(0xFF4CAF50)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '요청',
                            style: TextStyle(
                              color:
                                  !foodProvider.isShareMode
                                      ? Colors.white
                                      : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Share button
                ElevatedButton(
                  onPressed: () {
                    // TODO: 나눔하기 페이지로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    '나눔하기',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  '급한 식료품이 있어요!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  '총 ${foodProvider.filteredFoodItems.length}개',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Food items list
          Expanded(
            child: ListView.builder(
              itemCount: foodProvider.urgentFoodItems.length,
              itemBuilder: (context, index) {
                final item = foodProvider.urgentFoodItems[index];
                return FoodItemCard(
                  item: item,
                  onTap: () => _showItemDetailBottomSheet(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
