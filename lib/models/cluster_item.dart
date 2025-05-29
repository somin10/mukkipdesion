import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'food_item.dart';

class FoodCluster {
  final List<FoodItem> items;
  final NLatLng center;
  final String id;

  FoodCluster({required this.items, required this.center, required this.id});

  bool get isMultiple => items.length > 1;
  int get count => items.length;

  static NLatLng calculateCenter(List<FoodItem> items) {
    if (items.isEmpty) return NLatLng(0, 0);

    double lat = 0;
    double lng = 0;

    for (var item in items) {
      lat += item.latitude;
      lng += item.longitude;
    }

    return NLatLng(lat / items.length, lng / items.length);
  }
}
