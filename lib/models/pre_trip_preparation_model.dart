import 'package:flutter/foundation.dart';
import 'enums.dart';

class PreTripPreparation {
  final String id;
  final String name;
  final PreTripPreparationCategory category;
  final bool isForInternational;
  final bool isCustom;
  final bool isActive;
  final DateTime? scheduledDate;
  final bool isNotificationEnabled;

  const PreTripPreparation({
    required this.id,
    required this.name,
    required this.category,
    this.isForInternational = false,
    this.isCustom = false,
    this.isActive = true,
    this.scheduledDate,
    this.isNotificationEnabled = false,
  });

  PreTripPreparation copyWith({
    String? id,
    String? name,
    PreTripPreparationCategory? category,
    bool? isForInternational,
    bool? isCustom,
    bool? isActive,
    DateTime? scheduledDate,
    bool? isNotificationEnabled,
    bool clearScheduledDate = false,
  }) =>
      PreTripPreparation(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        isForInternational: isForInternational ?? this.isForInternational,
        isCustom: isCustom ?? this.isCustom,
        isActive: isActive ?? this.isActive,
        scheduledDate:
            clearScheduledDate ? null : (scheduledDate ?? this.scheduledDate),
        isNotificationEnabled: clearScheduledDate
            ? false
            : (isNotificationEnabled ?? this.isNotificationEnabled),
      );

  // ✅ clearScheduledDate için yardımcı metod
  PreTripPreparation clearSchedule() => copyWith(clearScheduledDate: true);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.index,
        'isForInternational': isForInternational,
        'isCustom': isCustom,
        'isActive': isActive,
        'scheduledDate': scheduledDate?.toIso8601String(),
        'isNotificationEnabled': isNotificationEnabled,
      };

  factory PreTripPreparation.fromJson(Map<String, dynamic> json) {
    try {
      // ✅ DateTime güvenli parse
      DateTime? parsedDate;
      final rawDate = json['scheduledDate'];
      if (rawDate != null && rawDate is String && rawDate.isNotEmpty) {
        try {
          parsedDate = DateTime.parse(rawDate);
        } catch (e) {
          debugPrint('⚠️ scheduledDate parse hatası: $rawDate');
          parsedDate = null;
        }
      }

      return PreTripPreparation(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        category: PreTripPreparationCategory.fromIndex(
          json['category'] as int?,
        ),
        isForInternational: json['isForInternational'] as bool? ?? false,
        isCustom: json['isCustom'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
        scheduledDate: parsedDate,
        isNotificationEnabled: json['isNotificationEnabled'] as bool? ?? false,
      );
    } catch (e) {
      debugPrint('❌ PreTripPreparation.fromJson hatası: $e, json: $json');
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTripPreparation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PreTripPreparation(id: $id, name: $name, category: $category)';
}
