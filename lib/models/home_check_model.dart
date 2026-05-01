import 'package:flutter/foundation.dart';
import 'enums.dart';

class HomeCheck {
  final String id;
  final String name;
  final HomeCheckCategory category;
  final bool isCustom;
  final bool isActive;

  const HomeCheck({
    required this.id,
    required this.name,
    required this.category,
    this.isCustom = false,
    this.isActive = true,
  });

  HomeCheck copyWith({
    String? id,
    String? name,
    HomeCheckCategory? category,
    bool? isCustom,
    bool? isActive,
  }) =>
      HomeCheck(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        isCustom: isCustom ?? this.isCustom,
        isActive: isActive ?? this.isActive,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.index,
        'isCustom': isCustom,
        'isActive': isActive,
      };

  factory HomeCheck.fromJson(Map<String, dynamic> json) {
    try {
      return HomeCheck(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        // ✅ Güvenli enum parse
        category: HomeCheckCategory.fromIndex(json['category'] as int?),
        isCustom: json['isCustom'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
      );
    } catch (e) {
      debugPrint('❌ HomeCheck.fromJson hatası: $e, json: $json');
      rethrow;
    }
  }

  // ✅ Equality ve hashCode - Set/Map kullanımı için
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeCheck && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'HomeCheck(id: $id, name: $name, category: $category)';
}
