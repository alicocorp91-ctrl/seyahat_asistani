import 'enums.dart';

class PreTripPreparation {
  final String id;
  final String name;
  final PreTripPreparationCategory category;
  final bool isForInternational; // true if only for international trips
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
  }) => PreTripPreparation(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    isForInternational: isForInternational ?? this.isForInternational,
    isCustom: isCustom ?? this.isCustom,
    isActive: isActive ?? this.isActive,
    scheduledDate: clearScheduledDate ? null : (scheduledDate ?? this.scheduledDate),
    isNotificationEnabled: clearScheduledDate ? false : (isNotificationEnabled ?? this.isNotificationEnabled),
  );

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

  factory PreTripPreparation.fromJson(Map<String, dynamic> json) => PreTripPreparation(
    id: json['id'] as String,
    name: json['name'] as String,
    category: PreTripPreparationCategory.values[json['category'] as int],
    isForInternational: json['isForInternational'] as bool? ?? false,
    isCustom: json['isCustom'] as bool? ?? false,
    isActive: json['isActive'] as bool? ?? true,
    scheduledDate: json['scheduledDate'] != null ? DateTime.parse(json['scheduledDate'] as String) : null,
    isNotificationEnabled: json['isNotificationEnabled'] as bool? ?? false,
  );
}