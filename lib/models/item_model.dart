import 'enums.dart';

class PackingItem {
  final String id;
  final String name;
  final ItemCategory category;
  final GenderVisibility genderVisibility;
  final List<Season> seasons;
  final List<Transport> transports;
  final bool internationalOnly;
  final bool isCustom;
  final bool isActive;

  const PackingItem({
    required this.id,
    required this.name,
    required this.category,
    this.genderVisibility = GenderVisibility.all,
    this.seasons = const [],
    this.transports = const [],
    this.internationalOnly = false,
    this.isCustom = false,
    this.isActive = true,
  });

  PackingItem copyWith({
    String? id,
    String? name,
    ItemCategory? category,
    GenderVisibility? genderVisibility,
    List<Season>? seasons,
    List<Transport>? transports,
    bool? internationalOnly,
    bool? isCustom,
    bool? isActive,
  }) {
    return PackingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      genderVisibility: genderVisibility ?? this.genderVisibility,
      seasons: seasons ?? this.seasons,
      transports: transports ?? this.transports,
      internationalOnly: internationalOnly ?? this.internationalOnly,
      isCustom: isCustom ?? this.isCustom,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.index,
    'genderVisibility': genderVisibility.index,
    'seasons': seasons.map((s) => s.index).toList(),
    'transports': transports.map((t) => t.index).toList(),
    'internationalOnly': internationalOnly,
    'isCustom': isCustom,
    'isActive': isActive,
  };

  factory PackingItem.fromJson(Map<String, dynamic> json) => PackingItem(
    id: json['id'] as String,
    name: json['name'] as String,
    category: ItemCategory.values[json['category'] as int],
    genderVisibility: GenderVisibility.values[json['genderVisibility'] as int],
    seasons: (json['seasons'] as List?)?.map((s) => Season.values[s as int]).toList() ?? [],
    transports: (json['transports'] as List?)?.map((t) => Transport.values[t as int]).toList() ?? [],
    internationalOnly: json['internationalOnly'] as bool? ?? false,
    isCustom: json['isCustom'] as bool? ?? false,
    isActive: json['isActive'] as bool? ?? true,
  );

  bool isVisibleFor({
    required Gender gender,
    required Season season,
    required Transport transport,
    required TripType tripType,
  }) {
    if (!isActive) return false;
    if (!genderVisibility.isVisibleFor(gender)) return false;
    if (seasons.isNotEmpty && !seasons.contains(season)) return false;
    if (transports.isNotEmpty && !transports.contains(transport)) return false;
    if (internationalOnly && tripType == TripType.domestic) return false;
    return true;
  }
}

class TripItem {
  final String itemId;
  final String name;
  final bool isPacked;
  final ItemCategory category;

  const TripItem({
    required this.itemId,
    required this.name,
    this.isPacked = false,
    required this.category,
  });

  TripItem copyWith({String? itemId, String? name, bool? isPacked, ItemCategory? category}) => TripItem(
    itemId: itemId ?? this.itemId,
    name: name ?? this.name,
    isPacked: isPacked ?? this.isPacked,
    category: category ?? this.category,
  );

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'name': name,
    'isPacked': isPacked,
    'category': category.index,
  };

  factory TripItem.fromJson(Map<String, dynamic> json) => TripItem(
    itemId: json['itemId'] as String,
    name: json['name'] as String,
    isPacked: json['isPacked'] as bool? ?? false,
    category: ItemCategory.values[json['category'] as int],
  );
}
