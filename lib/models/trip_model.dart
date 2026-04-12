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
  }) => Trip(
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
    completedPreTripPreparations: completedPreTripPreparations ?? this.completedPreTripPreparations,
  );

  int get days => endDate.difference(startDate).inDays + 1;
  int get packedCount => items.where((i) => i.isPacked).length;
  int get totalCount => items.length;
  double get progress => totalCount == 0 ? 0 : packedCount / totalCount;
  
  Duration get timeUntilStart => startDate.difference(DateTime.now());
  bool get hasStarted => DateTime.now().isAfter(startDate);
  bool get hasEnded => DateTime.now().isAfter(endDate);

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
    'preTripPreparations': preTripPreparations.map((p) => p.toJson()).toList(),
    'completedHomeChecks': completedHomeChecks,
    'completedPreTripPreparations': completedPreTripPreparations,
  };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    id: json['id'] as String,
    name: json['name'] as String,
    fromLocation: json['fromLocation'] as String? ?? '',
    toLocation: json['toLocation'] as String? ?? '',
    gender: Gender.values[json['gender'] as int],
    season: Season.values[json['season'] as int],
    transport: Transport.values[json['transport'] as int],
    tripType: TripType.values[json['tripType'] as int? ?? 0],
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    items: (json['items'] as List).map((i) => TripItem.fromJson(i)).toList(),
    homeChecks: (json['homeChecks'] as List?)?.map((c) => HomeCheck.fromJson(c)).toList() ?? [],
    preTripPreparations: (json['preTripPreparations'] as List?)?.map((p) => PreTripPreparation.fromJson(p)).toList() ?? [],
    completedHomeChecks: (json['completedHomeChecks'] as List?)?.cast<String>() ?? [],
    completedPreTripPreparations: (json['completedPreTripPreparations'] as List?)?.cast<String>() ?? [],
  );
}
