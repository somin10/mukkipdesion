import 'dart:math';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../models/food_item.dart';
import '../models/cluster_item.dart';

class ClusteringService {
  static const double _clusterDistanceMeters = 100.0; // 100미터 이내 클러스터링

  static List<FoodCluster> clusterItems(List<FoodItem> items, double zoom) {
    if (items.isEmpty) return [];

    // 줌 레벨에 따른 클러스터링 거리 조정
    // 줌 레벨이 높을수록(확대) 더 가까운 거리에서만 클러스터링
    double distanceThreshold = _clusterDistanceMeters * pow(2, (17 - zoom));

    List<FoodCluster> clusters = [];
    List<FoodItem> remainingItems = List.from(items);

    while (remainingItems.isNotEmpty) {
      FoodItem baseItem = remainingItems.removeAt(0);
      List<FoodItem> clusterItems = [baseItem];

      // 가까운 아이템들을 찾아서 클러스터에 추가
      remainingItems.removeWhere((item) {
        double distance = _calculateDistance(
          baseItem.latitude,
          baseItem.longitude,
          item.latitude,
          item.longitude,
        );

        if (distance < distanceThreshold) {
          clusterItems.add(item);
          return true;
        }
        return false;
      });

      // 2개 이상일 때만 클러스터로 처리 (요구사항에 따라)
      if (clusterItems.length >= 2 || zoom < 14) {
        clusters.add(
          FoodCluster(
            items: clusterItems,
            center: FoodCluster.calculateCenter(clusterItems),
            id: _generateClusterId(clusterItems),
          ),
        );
      } else {
        // 단일 아이템은 개별 클러스터로 생성
        for (var item in clusterItems) {
          clusters.add(
            FoodCluster(
              items: [item],
              center: NLatLng(item.latitude, item.longitude),
              id: item.id,
            ),
          );
        }
      }
    }

    return clusters;
  }

  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // 지구 반지름 (미터)

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  static String _generateClusterId(List<FoodItem> items) {
    return items.map((item) => item.id).join('_');
  }
}
