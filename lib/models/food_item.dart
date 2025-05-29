class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final FoodCategory category;
  final FoodFreshness freshness;
  final double latitude;
  final double longitude;
  final String ownerId;
  final String ownerName;
  final String ownerImageUrl;
  final double foodMannerScore;
  final int walkingMinutes;
  final bool isUrgent;
  final DateTime createdAt;
  final DateTime? expiryDate;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.freshness,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.ownerName,
    required this.ownerImageUrl,
    required this.foodMannerScore,
    required this.walkingMinutes,
    required this.isUrgent,
    required this.createdAt,
    this.expiryDate,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: FoodCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
      ),
      freshness: FoodFreshness.values.firstWhere(
        (e) => e.toString().split('.').last == json['freshness'],
      ),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      ownerImageUrl: json['ownerImageUrl'],
      foodMannerScore: json['foodMannerScore'].toDouble(),
      walkingMinutes: json['walkingMinutes'],
      isUrgent: json['isUrgent'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      expiryDate:
          json['expiryDate'] != null
              ? DateTime.parse(json['expiryDate'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category.toString().split('.').last,
      'freshness': freshness.toString().split('.').last,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerImageUrl': ownerImageUrl,
      'foodMannerScore': foodMannerScore,
      'walkingMinutes': walkingMinutes,
      'isUrgent': isUrgent,
      'createdAt': createdAt.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}

enum FoodCategory {
  urgent, // ⏰ 바로 드세요!
  vegetables, // 🥕 채소
  fruits, // 🍎 과일
  meat, // 🥩 육류
  dairy, // 🥛 유제품
  grains, // 🌾 곡류
  others, // 기타
}

enum FoodFreshness {
  fresh, // 아직 쌩쌩해요 ✨
  good, // 좋은 상태
  fair, // 보통
  urgent, // 급히 드세요!
}

extension FoodCategoryExtension on FoodCategory {
  String get displayName {
    switch (this) {
      case FoodCategory.urgent:
        return '⏰ 바로 드세요!';
      case FoodCategory.vegetables:
        return '🥕 채소';
      case FoodCategory.fruits:
        return '🍎 과일';
      case FoodCategory.meat:
        return '🥩 육류';
      case FoodCategory.dairy:
        return '🥛 유제품';
      case FoodCategory.grains:
        return '🌾 곡류';
      case FoodCategory.others:
        return '기타';
    }
  }

  String get emoji {
    switch (this) {
      case FoodCategory.urgent:
        return '⏰';
      case FoodCategory.vegetables:
        return '🥕';
      case FoodCategory.fruits:
        return '🍎';
      case FoodCategory.meat:
        return '🥩';
      case FoodCategory.dairy:
        return '🥛';
      case FoodCategory.grains:
        return '🌾';
      case FoodCategory.others:
        return '📦';
    }
  }
}

extension FoodFreshnessExtension on FoodFreshness {
  String get displayName {
    switch (this) {
      case FoodFreshness.fresh:
        return '아직 쌩쌩해요 ✨';
      case FoodFreshness.good:
        return '좋은 상태';
      case FoodFreshness.fair:
        return '보통';
      case FoodFreshness.urgent:
        return '급히 드세요!';
    }
  }

  String get emoji {
    switch (this) {
      case FoodFreshness.fresh:
        return '✨';
      case FoodFreshness.good:
        return '😊';
      case FoodFreshness.fair:
        return '😐';
      case FoodFreshness.urgent:
        return '⚡';
    }
  }
}
