import 'package:flutter/foundation.dart';
import 'enums.dart';
import 'item_model.dart';
import 'home_check_model.dart';
import 'pre_trip_preparation_model.dart';

class Trip {
  final String id;
  final String name;
  final String fromLocation;
  final String toLocation;
  final Gender gender;
  final Season season;
  final Transport transport;
  final TripType tripType;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final List<TripItem> items;
  final List<HomeCheck> homeChecks;
  final List<PreTripPreparation> preTripPreparations;
  final List<String> completedHomeChecks;
  final List<String> completedPreTripPreparations;

  const Trip({
    required this.id,
    required this.name,
    required this.fromLocation,
    required this.toLocation,
    required this.gender,
    required this.season,
    required this.transport,
    required this.tripType,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.items,
    this.homeChecks = const [],
    this.preTripPreparations = const [],
    this.completedHomeChecks = const [],
    this.completedPreTripPreparations = const [],
  });

  Trip copyWith({
    String? id,
    String? name,
    String? fromLocation,
    String? toLocation,
    Gender? gender,
    Season? season,
    Transport? transport,
    TripType? tripType,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    List<TripItem>? items,
    List<HomeCheck>? homeChecks,
    List<PreTripPreparation>? preTripPreparations,
    List<String>? completedHomeChecks,
    List<String>? completedPreTripPreparations,
  }) =>
      Trip(
        id: id ?? this.id,
        name: name ?? this.name,
        fromLocation: fromLocation ?? this.fromLocation,
        toLocation: toLocation ?? this.toLocation,
        gender: gender ?? this.gender,
        season: season ?? this.season,
        transport: transport ?? this.transport,
        tripType: tripType ?? this.tripType,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        items: items ?? this.items,
        homeChecks: homeChecks ?? this.homeChecks,
        preTripPreparations: preTripPreparations ?? this.preTripPreparations,
        completedHomeChecks: completedHomeChecks ?? this.completedHomeChecks,
        completedPreTripPreparations:
            completedPreTripPreparations ?? this.completedPreTripPreparations,
      );

  // ─── Computed Properties ────────────────────────────────────────────────────

  /// Gün sayısı (başlangıç günü dahil). Geçersiz tarih aralığı 1 gün kabul edilir.
  int get days => endDate.isBefore(startDate)
      ? 1
      : endDate.difference(startDate).inDays + 1;

  /// Paketlenen eşya sayısı
  int get packedCount => items.where((i) => i.isPacked).length;

  /// Toplam eşya sayısı
  int get totalCount => items.length;

  /// Paketleme ilerleme oranı (0.0 - 1.0)
  double get progress => totalCount == 0 ? 0.0 : packedCount / totalCount;

  /// Seyahate başlayana kadar kalan süre
  Duration get timeUntilStart => startDate.difference(DateTime.now());

  /// Seyahat başladı mı? Tam başlangıç anı da başlamış kabul edilir.
  bool get hasStarted => !DateTime.now().isBefore(startDate);

  /// Seyahat bitti mi? Bitiş tarihi gün sonu kabul edilir.
  bool get hasEnded => DateTime.now().isAfter(
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999),
      );

  /// Seyahat devam ediyor mu?
  bool get isOngoing => hasStarted && !hasEnded;

  /// Tamamlanan home check sayısı
  int get completedHomeCheckCount => completedHomeChecks.length;

  /// Toplam home check sayısı
  int get totalHomeCheckCount => homeChecks.length;

  /// Home check ilerleme oranı
  double get homeCheckProgress => totalHomeCheckCount == 0
      ? 0.0
      : completedHomeCheckCount / totalHomeCheckCount;

  /// Tamamlanan hazırlık sayısı
  int get completedPreparationCount => completedPreTripPreparations.length;

  /// Toplam hazırlık sayısı
  int get totalPreparationCount => preTripPreparations.length;

  /// Hazırlık ilerleme oranı
  double get preparationProgress => totalPreparationCount == 0
      ? 0.0
      : completedPreparationCount / totalPreparationCount;

  // ─── Serialization ──────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fromLocation': fromLocation,
        'toLocation': toLocation,
        'gender': gender.index,
        'season': season.index,
        'transport': transport.index,
        'tripType': tripType.index,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'homeChecks': homeChecks.map((c) => c.toJson()).toList(),
        'preTripPreparations':
            preTripPreparations.map((p) => p.toJson()).toList(),
        'completedHomeChecks': completedHomeChecks,
        'completedPreTripPreparations': completedPreTripPreparations,
      };

  factory Trip.fromJson(Map<String, dynamic> json) {
    try {
      return Trip(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        fromLocation: json['fromLocation']?.toString() ?? '',
        toLocation: json['toLocation']?.toString() ?? '',

        // ✅ Güvenli enum parse
        gender: Gender.fromIndex(json['gender'] as int?),
        season: Season.fromIndex(json['season'] as int?),
        transport: Transport.fromIndex(json['transport'] as int?),
        tripType: TripType.fromIndex(json['tripType'] as int?),

        // ✅ Güvenli DateTime parse
        startDate: _parseDate(json['startDate'], DateTime.now()),
        endDate: _parseDate(
          json['endDate'],
          DateTime.now().add(const Duration(days: 1)),
        ),
        createdAt: _parseDate(json['createdAt'], DateTime.now()),

        // ✅ Güvenli list parse
        items: _parseList(
          json['items'],
          TripItem.fromJson,
          'items',
        ),
        homeChecks: _parseList(
          json['homeChecks'],
          HomeCheck.fromJson,
          'homeChecks',
        ),
        preTripPreparations: _parseList(
          json['preTripPreparations'],
          PreTripPreparation.fromJson,
          'preTripPreparations',
        ),

        // ✅ Güvenli string list parse
        completedHomeChecks: _parseStringList(json['completedHomeChecks']),
        completedPreTripPreparations:
            _parseStringList(json['completedPreTripPreparations']),
      );
    } catch (e) {
      debugPrint('❌ Trip.fromJson hatası: $e');
      debugPrint('JSON: $json');
      rethrow;
    }
  }

  /// ✅ Güvenli DateTime parse
  static DateTime _parseDate(dynamic raw, DateTime fallback) {
    if (raw == null) return fallback;
    try {
      return DateTime.parse(raw.toString());
    } catch (e) {
      debugPrint('⚠️ DateTime parse hatası: $raw');
      return fallback;
    }
  }

  /// ✅ Güvenli model list parse
  static List<T> _parseList<T>(
    dynamic rawList,
    T Function(Map<String, dynamic>) fromJson,
    String fieldName,
  ) {
    if (rawList == null) return [];
    if (rawList is! List) {
      debugPrint('⚠️ $fieldName bir liste değil');
      return [];
    }
    return rawList
        .map((e) {
          try {
            if (e is! Map<String, dynamic>) return null;
            return fromJson(e);
          } catch (err) {
            debugPrint('⚠️ $fieldName parse hatası: $err');
            return null;
          }
        })
        .whereType<T>()
        .toList();
  }

  /// ✅ Güvenli string list parse
  static List<String> _parseStringList(dynamic rawList) {
    if (rawList == null) return [];
    if (rawList is! List) return [];
    return rawList.map((e) => e?.toString()).whereType<String>().toList();
  }

  // ─── Equality ───────────────────────────────────────────────────────────────
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trip && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Trip(id: $id, name: $name, '
      'from: $fromLocation → to: $toLocation)';
}
