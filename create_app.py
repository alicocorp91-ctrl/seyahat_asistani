#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Seyahat Asistani - Flutter Proje Olusturucu
Flutter 3.41.5 / Dart 3.11.3 uyumlu
Optimize edilmis, hafif ve akici
"""

import os
import sys

def create_project():
    print("=" * 50)
    print("Seyahat Asistani - Proje Olusturucu")
    print("=" * 50)
    
    print("\n[1/3] Flutter projesi olusturuluyor...")
    result = os.system("flutter create .")
    if result != 0:
        print("HATA: Flutter projesi olusturulamadi!")
        sys.exit(1)
    
    print("\n[2/3] pubspec.yaml guncelleniyor...")
    write_pubspec()
    
    print("\n[3/3] Dart dosyalari olusturuluyor...")
    create_lib_files()
    
    print("\n" + "=" * 50)
    print("TAMAMLANDI!")
    print("Calistirmak icin: flutter pub get && flutter run")
    print("=" * 50)

def write_pubspec():
    content = r'''name: seyahat_asistani
description: Seyahat Valiz Hazirlama Asistani
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  provider: ^6.1.1
  uuid: ^4.2.1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
'''
    with open("pubspec.yaml", "w", encoding="utf-8") as f:
        f.write(content)

def create_lib_files():
    files = {
        "lib/main.dart": get_main_dart(),
        "lib/models/enums.dart": get_enums_dart(),
        "lib/models/item_model.dart": get_item_model_dart(),
        "lib/models/trip_model.dart": get_trip_model_dart(),
        "lib/models/home_check_model.dart": get_home_check_model_dart(),
        "lib/data/default_items.dart": get_default_items_dart(),
        "lib/data/default_home_checks.dart": get_default_home_checks_dart(),
        "lib/providers/app_provider.dart": get_app_provider_dart(),
        "lib/screens/home_screen.dart": get_home_screen_dart(),
        "lib/screens/create_trip_screen.dart": get_create_trip_screen_dart(),
        "lib/screens/trip_detail_screen.dart": get_trip_detail_screen_dart(),
        "lib/screens/home_checks_screen.dart": get_home_checks_screen_dart(),
        "lib/screens/settings_screen.dart": get_settings_screen_dart(),
        "lib/screens/manage_items_screen.dart": get_manage_items_screen_dart(),
        "lib/screens/manage_home_checks_screen.dart": get_manage_home_checks_screen_dart(),
        "lib/widgets/item_tile.dart": get_item_tile_dart(),
        "lib/widgets/category_section.dart": get_category_section_dart(),
        "lib/widgets/countdown_widget.dart": get_countdown_widget_dart(),
        "lib/theme/app_theme.dart": get_app_theme_dart(),
    }
    
    for path, content in files.items():
        dir_path = os.path.dirname(path)
        if dir_path:
            os.makedirs(dir_path, exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"  + {path}")

def get_main_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..init(),
      child: MaterialApp(
        title: 'Seyahat Asistani',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
'''

def get_enums_dart():
    return r'''import 'package:flutter/material.dart';

enum Gender {
  male,
  female,
  couple;

  String get label {
    switch (this) {
      case Gender.male: return 'Erkek';
      case Gender.female: return 'Kadin';
      case Gender.couple: return 'Cift';
    }
  }

  IconData get iconData {
    switch (this) {
      case Gender.male: return Icons.man;
      case Gender.female: return Icons.woman;
      case Gender.couple: return Icons.people;
    }
  }
}

enum Season {
  spring,
  summer,
  autumn,
  winter;

  String get label {
    switch (this) {
      case Season.spring: return 'Ilkbahar';
      case Season.summer: return 'Yaz';
      case Season.autumn: return 'Sonbahar';
      case Season.winter: return 'Kis';
    }
  }

  IconData get iconData {
    switch (this) {
      case Season.spring: return Icons.local_florist;
      case Season.summer: return Icons.wb_sunny;
      case Season.autumn: return Icons.eco;
      case Season.winter: return Icons.ac_unit;
    }
  }
}

enum Transport {
  plane,
  car,
  bus,
  train;

  String get label {
    switch (this) {
      case Transport.plane: return 'Ucak';
      case Transport.car: return 'Araba';
      case Transport.bus: return 'Otobus';
      case Transport.train: return 'Tren';
    }
  }

  IconData get iconData {
    switch (this) {
      case Transport.plane: return Icons.flight;
      case Transport.car: return Icons.directions_car;
      case Transport.bus: return Icons.directions_bus;
      case Transport.train: return Icons.train;
    }
  }
}

enum TripType {
  domestic,
  international;

  String get label {
    switch (this) {
      case TripType.domestic: return 'Yurtici';
      case TripType.international: return 'Yurtdisi';
    }
  }

  IconData get iconData {
    switch (this) {
      case TripType.domestic: return Icons.home;
      case TripType.international: return Icons.public;
    }
  }
}

enum GenderVisibility {
  all,
  maleOnly,
  femaleOnly,
  coupleOnly,
  maleAndCouple,
  femaleAndCouple;

  bool isVisibleFor(Gender gender) {
    switch (this) {
      case GenderVisibility.all: return true;
      case GenderVisibility.maleOnly: return gender == Gender.male;
      case GenderVisibility.femaleOnly: return gender == Gender.female;
      case GenderVisibility.coupleOnly: return gender == Gender.couple;
      case GenderVisibility.maleAndCouple: return gender == Gender.male || gender == Gender.couple;
      case GenderVisibility.femaleAndCouple: return gender == Gender.female || gender == Gender.couple;
    }
  }

  String get label {
    switch (this) {
      case GenderVisibility.all: return 'Herkes';
      case GenderVisibility.maleOnly: return 'Sadece Erkek';
      case GenderVisibility.femaleOnly: return 'Sadece Kadin';
      case GenderVisibility.coupleOnly: return 'Sadece Cift';
      case GenderVisibility.maleAndCouple: return 'Erkek ve Cift';
      case GenderVisibility.femaleAndCouple: return 'Kadin ve Cift';
    }
  }
}

enum ItemCategory {
  clothingBasic,
  clothingMale,
  clothingFemale,
  clothingWinter,
  clothingSummer,
  personalCare,
  personalCareMale,
  personalCareFemale,
  health,
  electronics,
  documents,
  documentsIntl,
  intimate,
  transport,
  practical,
  other;

  String get label {
    switch (this) {
      case ItemCategory.clothingBasic: return 'Temel Giyim';
      case ItemCategory.clothingMale: return 'Erkek Giyim';
      case ItemCategory.clothingFemale: return 'Kadin Giyim';
      case ItemCategory.clothingWinter: return 'Kis Giyim';
      case ItemCategory.clothingSummer: return 'Yaz Giyim';
      case ItemCategory.personalCare: return 'Kisisel Bakim';
      case ItemCategory.personalCareMale: return 'Erkek Bakim';
      case ItemCategory.personalCareFemale: return 'Kadin Bakim';
      case ItemCategory.health: return 'Saglik ve Ilac';
      case ItemCategory.electronics: return 'Elektronik';
      case ItemCategory.documents: return 'Evrak ve Belge';
      case ItemCategory.documentsIntl: return 'Yurtdisi Belgeleri';
      case ItemCategory.intimate: return 'Ozel';
      case ItemCategory.transport: return 'Yolculuk Ekstra';
      case ItemCategory.practical: return 'Pratik Esyalar';
      case ItemCategory.other: return 'Diger';
    }
  }

  IconData get iconData {
    switch (this) {
      case ItemCategory.clothingBasic: return Icons.checkroom;
      case ItemCategory.clothingMale: return Icons.man;
      case ItemCategory.clothingFemale: return Icons.woman;
      case ItemCategory.clothingWinter: return Icons.ac_unit;
      case ItemCategory.clothingSummer: return Icons.wb_sunny;
      case ItemCategory.personalCare: return Icons.soap;
      case ItemCategory.personalCareMale: return Icons.face;
      case ItemCategory.personalCareFemale: return Icons.face_3;
      case ItemCategory.health: return Icons.medical_services;
      case ItemCategory.electronics: return Icons.devices;
      case ItemCategory.documents: return Icons.description;
      case ItemCategory.documentsIntl: return Icons.public;
      case ItemCategory.intimate: return Icons.lock;
      case ItemCategory.transport: return Icons.commute;
      case ItemCategory.practical: return Icons.handyman;
      case ItemCategory.other: return Icons.category;
    }
  }
}

enum HomeCheckCategory {
  electric,
  waterGas,
  kitchen,
  security,
  other;

  String get label {
    switch (this) {
      case HomeCheckCategory.electric: return 'Elektrik';
      case HomeCheckCategory.waterGas: return 'Su ve Gaz';
      case HomeCheckCategory.kitchen: return 'Mutfak';
      case HomeCheckCategory.security: return 'Guvenlik';
      case HomeCheckCategory.other: return 'Diger';
    }
  }

  IconData get iconData {
    switch (this) {
      case HomeCheckCategory.electric: return Icons.electrical_services;
      case HomeCheckCategory.waterGas: return Icons.water_drop;
      case HomeCheckCategory.kitchen: return Icons.kitchen;
      case HomeCheckCategory.security: return Icons.security;
      case HomeCheckCategory.other: return Icons.more_horiz;
    }
  }
}
'''

def get_item_model_dart():
    return r'''import 'enums.dart';

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
'''

def get_trip_model_dart():
    return r'''import 'enums.dart';
import 'item_model.dart';

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
  final List<String> completedHomeChecks;

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
    this.completedHomeChecks = const [],
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
    List<String>? completedHomeChecks,
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
    completedHomeChecks: completedHomeChecks ?? this.completedHomeChecks,
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
    'completedHomeChecks': completedHomeChecks,
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
    completedHomeChecks: (json['completedHomeChecks'] as List?)?.cast<String>() ?? [],
  );
}
'''

def get_home_check_model_dart():
    return r'''import 'enums.dart';

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

  HomeCheck copyWith({String? id, String? name, HomeCheckCategory? category, bool? isCustom, bool? isActive}) => HomeCheck(
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

  factory HomeCheck.fromJson(Map<String, dynamic> json) => HomeCheck(
    id: json['id'] as String,
    name: json['name'] as String,
    category: HomeCheckCategory.values[json['category'] as int],
    isCustom: json['isCustom'] as bool? ?? false,
    isActive: json['isActive'] as bool? ?? true,
  );
}
'''

def get_default_items_dart():
    return r'''import '../models/enums.dart';
import '../models/item_model.dart';

final List<PackingItem> defaultPackingItems = [
  // TEMEL GIYIM
  const PackingItem(id: 'underwear', name: 'Ic camasiri', category: ItemCategory.clothingBasic),
  const PackingItem(id: 'socks', name: 'Corap', category: ItemCategory.clothingBasic),
  const PackingItem(id: 'pajamas', name: 'Pijama takimi', category: ItemCategory.clothingBasic),
  const PackingItem(id: 'slippers', name: 'Terlik', category: ItemCategory.clothingBasic),
  const PackingItem(id: 'daily_shoes', name: 'Gunluk ayakkabi', category: ItemCategory.clothingBasic),
  const PackingItem(id: 'sport_shoes', name: 'Spor ayakkabi', category: ItemCategory.clothingBasic),

  // ERKEK GIYIM
  const PackingItem(id: 'tshirt_m', name: 'Tisort', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'pants_m', name: 'Pantolon', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'jeans_m', name: 'Kot pantolon', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'shorts_m', name: 'Sort', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'shirt_m', name: 'Gomlek', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'boxer', name: 'Boxer', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'undershirt', name: 'Atlet', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'belt', name: 'Kemer', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'suit', name: 'Takim elbise', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'tie', name: 'Kravat', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'jacket_m', name: 'Ceket', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'tracksuit_m', name: 'Esofman', category: ItemCategory.clothingMale, genderVisibility: GenderVisibility.maleAndCouple),

  // KADIN GIYIM
  const PackingItem(id: 'blouse', name: 'Bluz', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'skirt', name: 'Etek', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'dress', name: 'Elbise', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'leggings', name: 'Tayt', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'bra', name: 'Sutyen', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'panties', name: 'Kulot', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'shawl', name: 'Sal esarp', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'cardigan', name: 'Hirka', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'jeans_f', name: 'Kot pantolon', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'tracksuit_f', name: 'Esofman', category: ItemCategory.clothingFemale, genderVisibility: GenderVisibility.femaleAndCouple),

  // KIS GIYIM
  const PackingItem(id: 'coat', name: 'Mont kaban', category: ItemCategory.clothingWinter, seasons: [Season.winter, Season.autumn]),
  const PackingItem(id: 'sweater', name: 'Kazak', category: ItemCategory.clothingWinter, seasons: [Season.winter, Season.autumn]),
  const PackingItem(id: 'polar', name: 'Polar', category: ItemCategory.clothingWinter, seasons: [Season.winter]),
  const PackingItem(id: 'scarf', name: 'Atki', category: ItemCategory.clothingWinter, seasons: [Season.winter]),
  const PackingItem(id: 'beanie', name: 'Bere', category: ItemCategory.clothingWinter, seasons: [Season.winter]),
  const PackingItem(id: 'gloves', name: 'Eldiven', category: ItemCategory.clothingWinter, seasons: [Season.winter]),
  const PackingItem(id: 'boots', name: 'Bot', category: ItemCategory.clothingWinter, seasons: [Season.winter, Season.autumn]),
  const PackingItem(id: 'thermal_top', name: 'Termal iclik ust', category: ItemCategory.clothingWinter, seasons: [Season.winter]),
  const PackingItem(id: 'thermal_bottom', name: 'Termal iclik alt', category: ItemCategory.clothingWinter, seasons: [Season.winter]),
  const PackingItem(id: 'wool_socks', name: 'Yun corap', category: ItemCategory.clothingWinter, seasons: [Season.winter]),
  const PackingItem(id: 'snow_boots', name: 'Kar botu', category: ItemCategory.clothingWinter, seasons: [Season.winter]),

  // YAZ GIYIM
  const PackingItem(id: 'sunhat', name: 'Gunes sapkasi', category: ItemCategory.clothingSummer, seasons: [Season.summer]),
  const PackingItem(id: 'swimsuit_m', name: 'Mayo erkek', category: ItemCategory.clothingSummer, genderVisibility: GenderVisibility.maleAndCouple, seasons: [Season.summer]),
  const PackingItem(id: 'bikini', name: 'Bikini mayo', category: ItemCategory.clothingSummer, genderVisibility: GenderVisibility.femaleAndCouple, seasons: [Season.summer]),
  const PackingItem(id: 'beach_dress', name: 'Plaj elbisesi', category: ItemCategory.clothingSummer, genderVisibility: GenderVisibility.femaleAndCouple, seasons: [Season.summer]),
  const PackingItem(id: 'shorts_summer', name: 'Sort', category: ItemCategory.clothingSummer, seasons: [Season.summer]),
  const PackingItem(id: 'sandals', name: 'Sandalet', category: ItemCategory.clothingSummer, seasons: [Season.summer]),
  const PackingItem(id: 'water_shoes', name: 'Deniz ayakkabisi', category: ItemCategory.clothingSummer, seasons: [Season.summer]),

  // KISISEL BAKIM
  const PackingItem(id: 'toothbrush', name: 'Dis fircasi', category: ItemCategory.personalCare),
  const PackingItem(id: 'toothpaste', name: 'Dis macunu', category: ItemCategory.personalCare),
  const PackingItem(id: 'dental_floss', name: 'Dis ipi', category: ItemCategory.personalCare),
  const PackingItem(id: 'mouthwash', name: 'Agiz gargarasi', category: ItemCategory.personalCare),
  const PackingItem(id: 'shampoo', name: 'Sampuan', category: ItemCategory.personalCare),
  const PackingItem(id: 'conditioner', name: 'Sac kremi', category: ItemCategory.personalCare),
  const PackingItem(id: 'showergel', name: 'Dus jeli', category: ItemCategory.personalCare),
  const PackingItem(id: 'soap', name: 'Sabun', category: ItemCategory.personalCare),
  const PackingItem(id: 'deodorant', name: 'Deodorant', category: ItemCategory.personalCare),
  const PackingItem(id: 'perfume', name: 'Parfum', category: ItemCategory.personalCare),
  const PackingItem(id: 'comb', name: 'Tarak firca', category: ItemCategory.personalCare),
  const PackingItem(id: 'nailclipper', name: 'Tirnak makasi', category: ItemCategory.personalCare),
  const PackingItem(id: 'nailfile', name: 'Tirnak torpusu', category: ItemCategory.personalCare),
  const PackingItem(id: 'cottonswab', name: 'Kulak cubugu', category: ItemCategory.personalCare),
  const PackingItem(id: 'moisturizer', name: 'Nemlendirici', category: ItemCategory.personalCare),
  const PackingItem(id: 'lipbalm', name: 'Dudak nemlendiricisi', category: ItemCategory.personalCare),
  const PackingItem(id: 'handcream', name: 'El kremi', category: ItemCategory.personalCare),
  const PackingItem(id: 'tweezers', name: 'Cimbiz', category: ItemCategory.personalCare),
  const PackingItem(id: 'mirror', name: 'Kucuk ayna', category: ItemCategory.personalCare),
  const PackingItem(id: 'towel', name: 'Havlu', category: ItemCategory.personalCare),
  const PackingItem(id: 'shower_cap', name: 'Bone', category: ItemCategory.personalCare),

  // ERKEK BAKIM
  const PackingItem(id: 'razor', name: 'Tiras makinesi jilet', category: ItemCategory.personalCareMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'shavingfoam', name: 'Tiras kopugu jeli', category: ItemCategory.personalCareMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'aftershave', name: 'After shave', category: ItemCategory.personalCareMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'beardoil', name: 'Sakal yagi', category: ItemCategory.personalCareMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'beardcomb', name: 'Sakal taragi', category: ItemCategory.personalCareMale, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'nosehair', name: 'Burun kil makasi', category: ItemCategory.personalCareMale, genderVisibility: GenderVisibility.maleAndCouple),

  // KADIN BAKIM
  const PackingItem(id: 'makeupbag', name: 'Makyaj cantasi', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'foundation', name: 'Fondoten', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'powder', name: 'Pudra', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'blush', name: 'Allik', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'eyeshadow', name: 'Far paleti', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'eyeliner', name: 'Eyeliner', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'mascara', name: 'Maskara', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'browpencil', name: 'Kas kalemi', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'lipstick', name: 'Ruj', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'lipliner', name: 'Dudak kalemi', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'highlighter', name: 'Aydinlatici', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'contour', name: 'Kontur kiti', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'makeupsponge', name: 'Makyaj sungeri', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'brushset', name: 'Firca seti', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'makeupremover', name: 'Makyaj temizleyici', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'micellar', name: 'Misel su', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'pads', name: 'Ped tampon', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'dailypads', name: 'Gunluk ped', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'waxstrips', name: 'Agda bandi tuy dokucu', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'hairstraightener', name: 'Sac duzlestirici', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'curlingiron', name: 'Sac masasi', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'hairdryer', name: 'Sac kurutma makinesi', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'hairties', name: 'Sac tokasi lastik', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'headband', name: 'Sac bandi', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'nailpolish', name: 'Oje', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'acetone', name: 'Aseton', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'hairspray', name: 'Sac spreyi', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),
  const PackingItem(id: 'hairmousse', name: 'Sac kopugu', category: ItemCategory.personalCareFemale, genderVisibility: GenderVisibility.femaleAndCouple),

  // SAGLIK VE ILAC
  const PackingItem(id: 'painkiller', name: 'Agri kesici', category: ItemCategory.health),
  const PackingItem(id: 'antipyretic', name: 'Ates dusurucu', category: ItemCategory.health),
  const PackingItem(id: 'bandaid', name: 'Yara bandi', category: ItemCategory.health),
  const PackingItem(id: 'antiseptic', name: 'Antiseptik tenturdiyot', category: ItemCategory.health),
  const PackingItem(id: 'woundcream', name: 'Yara merhemi', category: ItemCategory.health),
  const PackingItem(id: 'bandage', name: 'Sargi bezi', category: ItemCategory.health),
  const PackingItem(id: 'stomachmeds', name: 'Mide ilaci', category: ItemCategory.health),
  const PackingItem(id: 'diarrhea', name: 'Ishal ilaci', category: ItemCategory.health),
  const PackingItem(id: 'laxative', name: 'Kabizlik ilaci', category: ItemCategory.health),
  const PackingItem(id: 'allergymeds', name: 'Alerji ilaci', category: ItemCategory.health),
  const PackingItem(id: 'coldmeds', name: 'Soguk alginligi ilaci', category: ItemCategory.health),
  const PackingItem(id: 'coughsyrup', name: 'Oksuruk surubu', category: ItemCategory.health),
  const PackingItem(id: 'nasalspray', name: 'Burun spreyi', category: ItemCategory.health),
  const PackingItem(id: 'throatlozenges', name: 'Bogaz pastili', category: ItemCategory.health),
  const PackingItem(id: 'prescriptionmeds', name: 'Receteli ilaclar', category: ItemCategory.health),
  const PackingItem(id: 'vitamins', name: 'Vitamin', category: ItemCategory.health),
  const PackingItem(id: 'sunscreen', name: 'Gunes kremi', category: ItemCategory.health),
  const PackingItem(id: 'bugspray', name: 'Bocek kovucu', category: ItemCategory.health),
  const PackingItem(id: 'bitecream', name: 'Bocek isirigi kremi', category: ItemCategory.health),
  const PackingItem(id: 'motionsickness', name: 'Seyahat tutmasi ilaci', category: ItemCategory.health),
  const PackingItem(id: 'eyedrops', name: 'Goz damlasi', category: ItemCategory.health),
  const PackingItem(id: 'lenssolution', name: 'Lens solusyonu', category: ItemCategory.health),
  const PackingItem(id: 'spareglasses', name: 'Yedek gozluk lens', category: ItemCategory.health),
  const PackingItem(id: 'handsanitizer', name: 'El dezenfektani', category: ItemCategory.health),
  const PackingItem(id: 'facemask', name: 'Maske', category: ItemCategory.health),
  const PackingItem(id: 'thermometer', name: 'Termometre', category: ItemCategory.health),

  // ELEKTRONIK
  const PackingItem(id: 'phone', name: 'Telefon', category: ItemCategory.electronics),
  const PackingItem(id: 'phonecharger', name: 'Telefon sarj aleti', category: ItemCategory.electronics),
  const PackingItem(id: 'powerbank', name: 'Powerbank', category: ItemCategory.electronics),
  const PackingItem(id: 'headphones', name: 'Kulaklik', category: ItemCategory.electronics),
  const PackingItem(id: 'tablet', name: 'Tablet', category: ItemCategory.electronics),
  const PackingItem(id: 'tabletcharger', name: 'Tablet sarj aleti', category: ItemCategory.electronics),
  const PackingItem(id: 'laptop', name: 'Laptop', category: ItemCategory.electronics),
  const PackingItem(id: 'laptopcharger', name: 'Laptop sarj aleti', category: ItemCategory.electronics),
  const PackingItem(id: 'camera', name: 'Fotograf makinesi', category: ItemCategory.electronics),
  const PackingItem(id: 'camerabattery', name: 'Kamera pili sarji', category: ItemCategory.electronics),
  const PackingItem(id: 'memorycard', name: 'Hafiza karti', category: ItemCategory.electronics),
  const PackingItem(id: 'usbdrive', name: 'USB bellek', category: ItemCategory.electronics),
  const PackingItem(id: 'usbcable', name: 'USB kablo', category: ItemCategory.electronics),
  const PackingItem(id: 'adapter', name: 'Priz adaptoru cevirici', category: ItemCategory.electronics),
  const PackingItem(id: 'ereader', name: 'E-kitap okuyucu', category: ItemCategory.electronics),
  const PackingItem(id: 'smartwatchcharger', name: 'Akilli saat sarji', category: ItemCategory.electronics),
  const PackingItem(id: 'speaker', name: 'Tasinabilir hoparlor', category: ItemCategory.electronics),
  const PackingItem(id: 'selfiestick', name: 'Selfie cubugu', category: ItemCategory.electronics),
  const PackingItem(id: 'tripod', name: 'Tripod', category: ItemCategory.electronics),

  // EVRAK VE BELGE
  const PackingItem(id: 'idcard', name: 'Kimlik karti', category: ItemCategory.documents),
  const PackingItem(id: 'driverlicense', name: 'Ehliyet', category: ItemCategory.documents),
  const PackingItem(id: 'tickets', name: 'Biletler', category: ItemCategory.documents),
  const PackingItem(id: 'hotelreservation', name: 'Otel rezervasyonu', category: ItemCategory.documents),
  const PackingItem(id: 'carrental', name: 'Arac kiralama belgesi', category: ItemCategory.documents),
  const PackingItem(id: 'insurance', name: 'Sigorta policesi', category: ItemCategory.documents),
  const PackingItem(id: 'creditcard', name: 'Kredi karti', category: ItemCategory.documents),
  const PackingItem(id: 'debitcard', name: 'Banka karti', category: ItemCategory.documents),
  const PackingItem(id: 'cash_tl', name: 'Nakit para TL', category: ItemCategory.documents),
  const PackingItem(id: 'studentcard', name: 'Ogrenci karti', category: ItemCategory.documents),
  const PackingItem(id: 'hoteladdress', name: 'Otel adresi telefonu', category: ItemCategory.documents),

  // YURTDISI BELGELERI
  const PackingItem(id: 'passport', name: 'Pasaport', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'visa', name: 'Vize belgeleri', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'intldriverlicense', name: 'Uluslararasi ehliyet', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'travelinsurance', name: 'Seyahat sigortasi', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'foreigncurrency', name: 'Doviz', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'intlcreditcard', name: 'Yurtdisi onaylı kredi karti', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'plugadapter', name: 'Priz adaptoru', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'roaminginfo', name: 'Roaming paketi bilgisi', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'embassycontact', name: 'Buyukelcilik iletisim', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'vaccinecard', name: 'Asi karti sertifikasi', category: ItemCategory.documentsIntl, internationalOnly: true),
  const PackingItem(id: 'photoid', name: 'Vesikalik fotograf', category: ItemCategory.documentsIntl, internationalOnly: true),

  // OZEL
  const PackingItem(id: 'condom', name: 'Prezervatif', category: ItemCategory.intimate, genderVisibility: GenderVisibility.maleAndCouple),
  const PackingItem(id: 'lubricant', name: 'Kayganlastirici', category: ItemCategory.intimate, genderVisibility: GenderVisibility.coupleOnly),
  const PackingItem(id: 'birthcontrol', name: 'Dogum kontrol hapi', category: ItemCategory.intimate, genderVisibility: GenderVisibility.femaleAndCouple),

  // YOLCULUK EKSTRA
  const PackingItem(id: 'neckpillow', name: 'Boyun yastigi', category: ItemCategory.transport),
  const PackingItem(id: 'sleepmask', name: 'Uyku maskesi', category: ItemCategory.transport),
  const PackingItem(id: 'earplugs', name: 'Kulak tikaci', category: ItemCategory.transport),
  const PackingItem(id: 'travelblanket', name: 'Seyahat battaniyesi', category: ItemCategory.transport),
  const PackingItem(id: 'inflatablepillow', name: 'Sisirilir yastik', category: ItemCategory.transport),
  const PackingItem(id: 'book', name: 'Kitap dergi', category: ItemCategory.transport),
  const PackingItem(id: 'puzzle', name: 'Bulmaca sudoku', category: ItemCategory.transport),
  const PackingItem(id: 'playingcards', name: 'Oyun kartlari', category: ItemCategory.transport),
  const PackingItem(id: 'phoneholder', name: 'Tablet telefon tutucu', category: ItemCategory.transport),
  const PackingItem(id: 'carcharger', name: 'Arac sarj cihazi', category: ItemCategory.transport, transports: [Transport.car]),
  const PackingItem(id: 'carphoneholder', name: 'Arac telefon tutacagi', category: ItemCategory.transport, transports: [Transport.car]),
  const PackingItem(id: 'navigation', name: 'Navigasyon', category: ItemCategory.transport, transports: [Transport.car]),
  const PackingItem(id: 'snacks', name: 'Atistirmalik', category: ItemCategory.transport),
  const PackingItem(id: 'waterbottle', name: 'Su sisesi', category: ItemCategory.transport),
  const PackingItem(id: 'thermos', name: 'Termos', category: ItemCategory.transport),
  const PackingItem(id: 'baglock', name: 'Canta kilidi', category: ItemCategory.transport),
  const PackingItem(id: 'luggagetag', name: 'Valiz etiketi', category: ItemCategory.transport),

  // PRATIK ESYALAR
  const PackingItem(id: 'sewingkit', name: 'Igne iplik seti', category: ItemCategory.practical),
  const PackingItem(id: 'safetypin', name: 'Cengelli igne', category: ItemCategory.practical),
  const PackingItem(id: 'scissors', name: 'Kucuk makas', category: ItemCategory.practical),
  const PackingItem(id: 'tape', name: 'Bant', category: ItemCategory.practical),
  const PackingItem(id: 'plasticbag', name: 'Plastik poset', category: ItemCategory.practical),
  const PackingItem(id: 'zipbag', name: 'Kilitli poset', category: ItemCategory.practical),
  const PackingItem(id: 'clothespin', name: 'Camasir mandali', category: ItemCategory.practical),
  const PackingItem(id: 'clothesline', name: 'Camasir ipi', category: ItemCategory.practical),
  const PackingItem(id: 'stainremover', name: 'Leke cikarici', category: ItemCategory.practical),
  const PackingItem(id: 'shoecare', name: 'Ayakkabi bakimi boyasi', category: ItemCategory.practical),
  const PackingItem(id: 'umbrella', name: 'Semsiye', category: ItemCategory.practical),
  const PackingItem(id: 'raincoat', name: 'Yagmurluk', category: ItemCategory.practical),
  const PackingItem(id: 'sunglasses', name: 'Gunes gozlugu', category: ItemCategory.practical),
  const PackingItem(id: 'glassescase', name: 'Gozluk kilifi', category: ItemCategory.practical),
  const PackingItem(id: 'flashlight', name: 'El feneri', category: ItemCategory.practical),
  const PackingItem(id: 'multitool', name: 'Caki cok amacli alet', category: ItemCategory.practical),
  const PackingItem(id: 'lighter', name: 'Cakmak kibrit', category: ItemCategory.practical),
  const PackingItem(id: 'pen', name: 'Kalem', category: ItemCategory.practical),
  const PackingItem(id: 'notebook', name: 'Not defteri', category: ItemCategory.practical),
  const PackingItem(id: 'map', name: 'Harita', category: ItemCategory.practical),
  const PackingItem(id: 'guidebook', name: 'Rehber kitap', category: ItemCategory.practical),
  const PackingItem(id: 'wallet', name: 'Cuzdan', category: ItemCategory.practical),
  const PackingItem(id: 'beltbag', name: 'Bel cantasi', category: ItemCategory.practical),
  const PackingItem(id: 'daypack', name: 'Gunluk sirt cantasi', category: ItemCategory.practical),
  const PackingItem(id: 'beachbag', name: 'Plaj cantasi', category: ItemCategory.practical, seasons: [Season.summer]),
  const PackingItem(id: 'laundrybag', name: 'Kirli camasir torbasi', category: ItemCategory.practical),
  const PackingItem(id: 'shoebag', name: 'Ayakkabi torbasi', category: ItemCategory.practical),
  const PackingItem(id: 'toiletrybag', name: 'Tuvalet cantasi', category: ItemCategory.practical),
  const PackingItem(id: 'whistle', name: 'Duduk acil durum', category: ItemCategory.practical),
];
'''

def get_default_home_checks_dart():
    return r'''import '../models/enums.dart';
import '../models/home_check_model.dart';

final List<HomeCheck> defaultHomeChecks = [
  // ELEKTRIK
  const HomeCheck(id: 'lights', name: 'Tum isiklari kapat', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'tv', name: 'TV fisini cek', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'ac', name: 'Klima isitici kapat', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'plugs', name: 'Gereksiz prizleri cek', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'computer', name: 'Bilgisayar kapat', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'chargers', name: 'Sarj aletlerini cek', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'washingmachine', name: 'Camasir bulaşik makinesi kapali mi', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'iron', name: 'Utu kapali mi', category: HomeCheckCategory.electric),

  // SU VE GAZ
  const HomeCheck(id: 'mainwater', name: 'Ana su vanasini kapat', category: HomeCheckCategory.waterGas),
  const HomeCheck(id: 'faucets', name: 'Musluklari kontrol et', category: HomeCheckCategory.waterGas),
  const HomeCheck(id: 'gasvalve', name: 'Dogalgaz vanasini kapat', category: HomeCheckCategory.waterGas),
  const HomeCheck(id: 'gastube', name: 'Tup varsa kontrol et', category: HomeCheckCategory.waterGas),
  const HomeCheck(id: 'toilet', name: 'Klozet sifonu kontrol', category: HomeCheckCategory.waterGas),

  // MUTFAK
  const HomeCheck(id: 'fridge', name: 'Buzdolabi kontrol bozulacaklar', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'trash', name: 'Copu at', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'recycle', name: 'Geri donusumu at', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'dishwasher', name: 'Bulasik makinesi bosalt', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'oven', name: 'Firin ocak kapali mi', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'foodarrange', name: 'Yiyecekleri duzenle', category: HomeCheckCategory.kitchen),

  // GUVENLIK
  const HomeCheck(id: 'windows', name: 'Tum pencereleri kapat', category: HomeCheckCategory.security),
  const HomeCheck(id: 'balcony', name: 'Balkon kapisini kilitle', category: HomeCheckCategory.security),
  const HomeCheck(id: 'door', name: 'Kapiyi kilitle', category: HomeCheckCategory.security),
  const HomeCheck(id: 'alarm', name: 'Alarm sistemi aktif et', category: HomeCheckCategory.security),
  const HomeCheck(id: 'camera', name: 'Kamera sistemi kontrol', category: HomeCheckCategory.security),
  const HomeCheck(id: 'sparekey', name: 'Yedek anahtari birine ver', category: HomeCheckCategory.security),
  const HomeCheck(id: 'valuables', name: 'Degerli esyalari sakla', category: HomeCheckCategory.security),
  const HomeCheck(id: 'mailbox', name: 'Posta kutusunu bosalt', category: HomeCheckCategory.security),

  // DIGER
  const HomeCheck(id: 'plants', name: 'Bitkileri sula', category: HomeCheckCategory.other),
  const HomeCheck(id: 'plantcare', name: 'Bitkiler icin duzenleme yap', category: HomeCheckCategory.other),
  const HomeCheck(id: 'pets', name: 'Evcil hayvan duzenlemesi', category: HomeCheckCategory.other),
  const HomeCheck(id: 'mail', name: 'Posta kargo duzenlemesi', category: HomeCheckCategory.other),
  const HomeCheck(id: 'thermostat', name: 'Termostati ayarla', category: HomeCheckCategory.other),
  const HomeCheck(id: 'blinds', name: 'Panjur perde kapat', category: HomeCheckCategory.other),
  const HomeCheck(id: 'timerlamp', name: 'Zamanlayici lamba kur', category: HomeCheckCategory.other),
  const HomeCheck(id: 'neighbor', name: 'Komsuyu bilgilendir', category: HomeCheckCategory.other),
];
'''

def get_app_provider_dart():
    return r'''import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../models/trip_model.dart';
import '../models/home_check_model.dart';
import '../data/default_items.dart';
import '../data/default_home_checks.dart';

class AppProvider extends ChangeNotifier {
  List<PackingItem> _allItems = [];
  List<HomeCheck> _allHomeChecks = [];
  List<Trip> _trips = [];
  Map<String, bool> _itemActiveStatus = {};
  Map<String, bool> _checkActiveStatus = {};
  bool _isLoading = true;

  List<PackingItem> get allItems => _allItems;
  List<HomeCheck> get allHomeChecks => _allHomeChecks;
  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;

  final _uuid = const Uuid();

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // Item active status
    final itemStatusJson = prefs.getString('item_status');
    if (itemStatusJson != null) {
      _itemActiveStatus = Map<String, bool>.from(jsonDecode(itemStatusJson));
    }

    // Check active status
    final checkStatusJson = prefs.getString('check_status');
    if (checkStatusJson != null) {
      _checkActiveStatus = Map<String, bool>.from(jsonDecode(checkStatusJson));
    }

    // Custom items
    final customItemsJson = prefs.getString('custom_items');
    List<PackingItem> customItems = [];
    if (customItemsJson != null) {
      customItems = (jsonDecode(customItemsJson) as List).map((e) => PackingItem.fromJson(e)).toList();
    }

    // Merge default + custom items with active status
    _allItems = [
      ...defaultPackingItems.map((item) => item.copyWith(
        isActive: _itemActiveStatus[item.id] ?? true,
      )),
      ...customItems,
    ];

    // Custom home checks
    final customChecksJson = prefs.getString('custom_checks');
    List<HomeCheck> customChecks = [];
    if (customChecksJson != null) {
      customChecks = (jsonDecode(customChecksJson) as List).map((e) => HomeCheck.fromJson(e)).toList();
    }

    _allHomeChecks = [
      ...defaultHomeChecks.map((check) => check.copyWith(
        isActive: _checkActiveStatus[check.id] ?? true,
      )),
      ...customChecks,
    ];

    // Trips
    final tripsJson = prefs.getString('trips');
    if (tripsJson != null) {
      _trips = (jsonDecode(tripsJson) as List).map((e) => Trip.fromJson(e)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveItemStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('item_status', jsonEncode(_itemActiveStatus));
  }

  Future<void> _saveCheckStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('check_status', jsonEncode(_checkActiveStatus));
  }

  Future<void> _saveCustomItems() async {
    final prefs = await SharedPreferences.getInstance();
    final customItems = _allItems.where((i) => i.isCustom).toList();
    await prefs.setString('custom_items', jsonEncode(customItems.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveCustomChecks() async {
    final prefs = await SharedPreferences.getInstance();
    final customChecks = _allHomeChecks.where((c) => c.isCustom).toList();
    await prefs.setString('custom_checks', jsonEncode(customChecks.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveTrips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trips', jsonEncode(_trips.map((e) => e.toJson()).toList()));
  }

  // Toggle item active
  Future<void> toggleItemActive(String id) async {
    final index = _allItems.indexWhere((i) => i.id == id);
    if (index != -1) {
      final item = _allItems[index];
      _allItems[index] = item.copyWith(isActive: !item.isActive);
      _itemActiveStatus[id] = _allItems[index].isActive;
      await _saveItemStatus();
      if (item.isCustom) await _saveCustomItems();
      notifyListeners();
    }
  }

  // Toggle check active
  Future<void> toggleCheckActive(String id) async {
    final index = _allHomeChecks.indexWhere((c) => c.id == id);
    if (index != -1) {
      final check = _allHomeChecks[index];
      _allHomeChecks[index] = check.copyWith(isActive: !check.isActive);
      _checkActiveStatus[id] = _allHomeChecks[index].isActive;
      await _saveCheckStatus();
      if (check.isCustom) await _saveCustomChecks();
      notifyListeners();
    }
  }

  // Add custom item
  Future<void> addCustomItem(PackingItem item) async {
    final newItem = item.copyWith(id: _uuid.v4(), isCustom: true, isActive: true);
    _allItems.add(newItem);
    await _saveCustomItems();
    notifyListeners();
  }

  // Delete custom item
  Future<void> deleteCustomItem(String id) async {
    _allItems.removeWhere((i) => i.id == id && i.isCustom);
    await _saveCustomItems();
    notifyListeners();
  }

  // Add custom check
  Future<void> addCustomCheck(HomeCheck check) async {
    final newCheck = check.copyWith(id: _uuid.v4(), isCustom: true, isActive: true);
    _allHomeChecks.add(newCheck);
    await _saveCustomChecks();
    notifyListeners();
  }

  // Delete custom check
  Future<void> deleteCustomCheck(String id) async {
    _allHomeChecks.removeWhere((c) => c.id == id && c.isCustom);
    await _saveCustomChecks();
    notifyListeners();
  }

  // Create trip
  Trip createTrip({
    required String name,
    required String fromLocation,
    required String toLocation,
    required Gender gender,
    required Season season,
    required Transport transport,
    required TripType tripType,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final filteredItems = _allItems.where((item) => item.isVisibleFor(
      gender: gender,
      season: season,
      transport: transport,
      tripType: tripType,
    )).toList();

    final tripItems = filteredItems.map((item) => TripItem(
      itemId: item.id,
      name: item.name,
      category: item.category,
    )).toList();

    final trip = Trip(
      id: _uuid.v4(),
      name: name,
      fromLocation: fromLocation,
      toLocation: toLocation,
      gender: gender,
      season: season,
      transport: transport,
      tripType: tripType,
      startDate: startDate,
      endDate: endDate,
      createdAt: DateTime.now(),
      items: tripItems,
    );

    _trips.insert(0, trip);
    _saveTrips();
    notifyListeners();
    return trip;
  }

  Future<void> toggleItemPacked(String tripId, String itemId) async {
    final tripIndex = _trips.indexWhere((t) => t.id == tripId);
    if (tripIndex == -1) return;

    final trip = _trips[tripIndex];
    final itemIndex = trip.items.indexWhere((i) => i.itemId == itemId);
    if (itemIndex == -1) return;

    final updatedItems = List<TripItem>.from(trip.items);
    updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(isPacked: !updatedItems[itemIndex].isPacked);

    _trips[tripIndex] = trip.copyWith(items: updatedItems);
    await _saveTrips();
    notifyListeners();
  }

  Future<void> toggleHomeCheck(String tripId, String checkId) async {
    final tripIndex = _trips.indexWhere((t) => t.id == tripId);
    if (tripIndex == -1) return;

    final trip = _trips[tripIndex];
    final completed = List<String>.from(trip.completedHomeChecks);

    if (completed.contains(checkId)) {
      completed.remove(checkId);
    } else {
      completed.add(checkId);
    }

    _trips[tripIndex] = trip.copyWith(completedHomeChecks: completed);
    await _saveTrips();
    notifyListeners();
  }

  Future<void> deleteTrip(String id) async {
    _trips.removeWhere((t) => t.id == id);
    await _saveTrips();
    notifyListeners();
  }

  Trip? getTripById(String id) {
    try {
      return _trips.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
'''

def get_home_screen_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/trip_model.dart';
import '../widgets/countdown_widget.dart';
import 'create_trip_screen.dart';
import 'trip_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seyahat Asistani'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.luggage_outlined, size: 80, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Henuz seyahat yok', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Yeni seyahat icin + tusuna basin', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.trips.length,
            itemBuilder: (context, index) => _TripCard(trip: provider.trips[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTripScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Seyahat'),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy', 'tr_TR');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip.id)));
        },
        onLongPress: () {
          HapticFeedback.heavyImpact();
          _showDeleteDialog(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(trip.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trip.tripType.index == 0 ? theme.colorScheme.primaryContainer : theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(trip.tripType.label, style: theme.textTheme.labelSmall),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Expanded(child: Text('${trip.fromLocation} - ${trip.toLocation}', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text('${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}', style: theme.textTheme.bodySmall),
                  const Spacer(),
                  Text('${trip.days} gun', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(trip.season.iconData, size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(trip.season.label, style: theme.textTheme.bodySmall),
                  const SizedBox(width: 12),
                  Icon(trip.transport.iconData, size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(trip.transport.label, style: theme.textTheme.bodySmall),
                  const SizedBox(width: 12),
                  Icon(trip.gender.iconData, size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(trip.gender.label, style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 12),
              if (!trip.hasStarted) CountdownWidget(targetDate: trip.startDate),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: trip.progress, minHeight: 8, backgroundColor: theme.colorScheme.surfaceContainerHighest),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${trip.packedCount}/${trip.totalCount}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seyahati Sil'),
        content: Text('${trip.name} seyahatini silmek istiyor musunuz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Iptal')),
          FilledButton(
            onPressed: () {
              context.read<AppProvider>().deleteTrip(trip.id);
              Navigator.pop(ctx);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
'''

def get_create_trip_screen_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/enums.dart';
import '../providers/app_provider.dart';
import 'trip_detail_screen.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _nameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  
  Gender _gender = Gender.male;
  Season _season = Season.summer;
  Transport _transport = Transport.plane;
  TripType _tripType = TripType.domestic;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 4));

  @override
  void dispose() {
    _nameController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  int get _days => _endDate.difference(_startDate).inDays + 1;

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          if (picked.isAfter(_startDate) || picked.isAtSameMomentAs(_startDate)) {
            _endDate = picked;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy', 'tr_TR');

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Seyahat'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Seyahat Adi', hintText: 'Ornegin: Antalya Tatili', prefixIcon: Icon(Icons.edit)),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fromController,
                    decoration: const InputDecoration(labelText: 'Nereden', hintText: 'Istanbul', prefixIcon: Icon(Icons.flight_takeoff)),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _toController,
                    decoration: const InputDecoration(labelText: 'Nereye', hintText: 'Antalya', prefixIcon: Icon(Icons.flight_land)),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text('Seyahat Tipi', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<TripType>(
              segments: TripType.values.map((t) => ButtonSegment(value: t, label: Text(t.label), icon: Icon(t.iconData))).toList(),
              selected: {_tripType},
              onSelectionChanged: (set) {
                HapticFeedback.selectionClick();
                setState(() => _tripType = set.first);
              },
            ),
            const SizedBox(height: 24),

            Text('Tarihler', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateFormat.format(_startDate)),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateFormat.format(_endDate)),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('$_days gun', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),

            Text('Kisi Tipi', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<Gender>(
              segments: Gender.values.map((g) => ButtonSegment(value: g, label: Text(g.label), icon: Icon(g.iconData))).toList(),
              selected: {_gender},
              onSelectionChanged: (set) {
                HapticFeedback.selectionClick();
                setState(() => _gender = set.first);
              },
            ),
            const SizedBox(height: 24),

            Text('Mevsim', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Season.values.map((s) => FilterChip(
                selected: _season == s,
                label: Text(s.label),
                avatar: Icon(s.iconData, size: 18),
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  setState(() => _season = s);
                },
              )).toList(),
            ),
            const SizedBox(height: 24),

            Text('Ulasim Araci', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Transport.values.map((t) => FilterChip(
                selected: _transport == t,
                label: Text(t.label),
                avatar: Icon(t.iconData, size: 18),
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  setState(() => _transport = t);
                },
              )).toList(),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _createTrip,
                icon: const Icon(Icons.check),
                label: const Text('Seyahat Olustur'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createTrip() {
    final name = _nameController.text.trim();
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (name.isEmpty || from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lutfen tum alanlari doldurun')));
      return;
    }

    HapticFeedback.heavyImpact();

    final trip = context.read<AppProvider>().createTrip(
      name: name,
      fromLocation: from,
      toLocation: to,
      gender: _gender,
      season: _season,
      transport: _transport,
      tripType: _tripType,
      startDate: _startDate,
      endDate: _endDate,
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip.id)));
  }
}
'''

def get_trip_detail_screen_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/enums.dart';
import '../models/trip_model.dart';
import '../providers/app_provider.dart';
import '../widgets/category_section.dart';
import '../widgets/countdown_widget.dart';
import 'home_checks_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final String tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final trip = provider.getTripById(widget.tripId);
        if (trip == null) {
          return Scaffold(appBar: AppBar(title: const Text('Hata')), body: const Center(child: Text('Seyahat bulunamadi')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(trip.name),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.luggage), text: 'Esyalar'),
                Tab(icon: Icon(Icons.home), text: 'Ev Kontrol'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _PackingListTab(trip: trip),
              HomeChecksScreen(tripId: trip.id),
            ],
          ),
        );
      },
    );
  }
}

class _PackingListTab extends StatelessWidget {
  final Trip trip;
  const _PackingListTab({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM', 'tr_TR');

    final Map<ItemCategory, List<dynamic>> grouped = {};
    for (final item in trip.items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Expanded(child: Text('${trip.fromLocation} → ${trip.toLocation}', style: theme.textTheme.bodyMedium)),
                  Text('${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}', style: theme.textTheme.bodySmall),
                ],
              ),
              if (!trip.hasStarted) ...[
                const SizedBox(height: 8),
                CountdownWidget(targetDate: trip.startDate),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: trip.progress, minHeight: 10),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                    child: Text('${trip.packedCount}/${trip.totalCount}', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategorySection(category: category, items: grouped[category]!, tripId: trip.id);
            },
          ),
        ),
      ],
    );
  }
}
'''

def get_home_checks_screen_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/home_check_model.dart';
import '../providers/app_provider.dart';

class HomeChecksScreen extends StatelessWidget {
  final String tripId;
  const HomeChecksScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final trip = provider.getTripById(tripId);
        if (trip == null) return const SizedBox.shrink();

        final completedChecks = trip.completedHomeChecks;
        final activeChecks = provider.allHomeChecks.where((c) => c.isActive).toList();

        final Map<HomeCheckCategory, List<HomeCheck>> grouped = {};
        for (final check in activeChecks) {
          grouped.putIfAbsent(check.category, () => []).add(check);
        }
        final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

        final totalChecks = activeChecks.length;
        final completedCount = completedChecks.where((id) => activeChecks.any((c) => c.id == id)).length;
        final progress = totalChecks == 0 ? 0.0 : completedCount / totalChecks;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ev Kontrolleri', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: progress, minHeight: 10, color: theme.colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: theme.colorScheme.secondary, borderRadius: BorderRadius.circular(8)),
                    child: Text('$completedCount/$totalChecks', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSecondary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final checks = grouped[category]!;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(category.iconData, color: theme.colorScheme.secondary),
                              const SizedBox(width: 8),
                              Text(category.label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        ...checks.map((check) {
                          final isCompleted = completedChecks.contains(check.id);
                          return ListTile(
                            leading: Checkbox(
                              value: isCompleted,
                              onChanged: (_) {
                                HapticFeedback.selectionClick();
                                provider.toggleHomeCheck(tripId, check.id);
                              },
                            ),
                            title: Text(
                              check.name,
                              style: TextStyle(
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                                color: isCompleted ? theme.colorScheme.onSurface.withValues(alpha: 0.5) : null,
                              ),
                            ),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              provider.toggleHomeCheck(tripId, check.id);
                            },
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
'''

def get_settings_screen_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'manage_items_screen.dart';
import 'manage_home_checks_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.luggage),
              title: const Text('Valiz Esyalarini Yonet'),
              subtitle: const Text('Esya ekle cikar veya kapat'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageItemsScreen()));
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ev Kontrollerini Yonet'),
              subtitle: const Text('Kontrol ekle cikar veya kapat'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageHomeChecksScreen()));
              },
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hakkinda', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Seyahat Asistani v1.0.0', style: theme.textTheme.bodyMedium),
                  Text('Valiz hazirlama ve ev kontrolu asistani', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
'''

def get_manage_items_screen_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../providers/app_provider.dart';

class ManageItemsScreen extends StatelessWidget {
  const ManageItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esyalari Yonet'), centerTitle: true),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<ItemCategory, List<PackingItem>> grouped = {};
          for (final item in provider.allItems) {
            grouped.putIfAbsent(item.category, () => []).add(item);
          }
          final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(category: category, items: grouped[category]!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Esya Ekle'),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const _AddItemSheet());
  }
}

class _CategoryCard extends StatelessWidget {
  final ItemCategory category;
  final List<PackingItem> items;
  const _CategoryCard({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = items.where((i) => i.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(category.iconData, color: theme.colorScheme.primary),
        title: Text(category.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$activeCount/${items.length} aktif'),
        children: items.map((item) {
          return ListTile(
            dense: true,
            leading: Switch(
              value: item.isActive,
              onChanged: (_) {
                HapticFeedback.selectionClick();
                context.read<AppProvider>().toggleItemActive(item.id);
              },
            ),
            title: Text(item.name, style: TextStyle(color: item.isActive ? null : theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            subtitle: Text(item.genderVisibility.label, style: theme.textTheme.bodySmall),
            trailing: item.isCustom
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<AppProvider>().deleteCustomItem(item.id);
                    },
                  )
                : null,
          );
        }).toList(),
      ),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet();

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _nameController = TextEditingController();
  ItemCategory _category = ItemCategory.other;
  GenderVisibility _visibility = GenderVisibility.all;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Yeni Esya Ekle', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Esya Adi', prefixIcon: Icon(Icons.edit)), textCapitalization: TextCapitalization.words),
            const SizedBox(height: 16),
            DropdownButtonFormField<ItemCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Kategori', prefixIcon: Icon(Icons.category)),
              items: ItemCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<GenderVisibility>(
              value: _visibility,
              decoration: const InputDecoration(labelText: 'Kimler Gorsun', prefixIcon: Icon(Icons.people)),
              items: GenderVisibility.values.map((v) => DropdownMenuItem(value: v, child: Text(v.label))).toList(),
              onChanged: (val) => setState(() => _visibility = val!),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _addItem, icon: const Icon(Icons.add), label: const Text('Ekle'))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lutfen esya adi girin')));
      return;
    }
    HapticFeedback.heavyImpact();
    context.read<AppProvider>().addCustomItem(PackingItem(id: '', name: name, category: _category, genderVisibility: _visibility));
    Navigator.pop(context);
  }
}
'''

def get_manage_home_checks_screen_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/home_check_model.dart';
import '../providers/app_provider.dart';

class ManageHomeChecksScreen extends StatelessWidget {
  const ManageHomeChecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ev Kontrollerini Yonet'), centerTitle: true),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<HomeCheckCategory, List<HomeCheck>> grouped = {};
          for (final check in provider.allHomeChecks) {
            grouped.putIfAbsent(check.category, () => []).add(check);
          }
          final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(category: category, checks: grouped[category]!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCheckDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Kontrol Ekle'),
      ),
    );
  }

  void _showAddCheckDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const _AddCheckSheet());
  }
}

class _CategoryCard extends StatelessWidget {
  final HomeCheckCategory category;
  final List<HomeCheck> checks;
  const _CategoryCard({required this.category, required this.checks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = checks.where((c) => c.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(category.iconData, color: theme.colorScheme.secondary),
        title: Text(category.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$activeCount/${checks.length} aktif'),
        children: checks.map((check) {
          return ListTile(
            dense: true,
            leading: Switch(
              value: check.isActive,
              onChanged: (_) {
                HapticFeedback.selectionClick();
                context.read<AppProvider>().toggleCheckActive(check.id);
              },
            ),
            title: Text(check.name, style: TextStyle(color: check.isActive ? null : theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            trailing: check.isCustom
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<AppProvider>().deleteCustomCheck(check.id);
                    },
                  )
                : null,
          );
        }).toList(),
      ),
    );
  }
}

class _AddCheckSheet extends StatefulWidget {
  const _AddCheckSheet();

  @override
  State<_AddCheckSheet> createState() => _AddCheckSheetState();
}

class _AddCheckSheetState extends State<_AddCheckSheet> {
  final _nameController = TextEditingController();
  HomeCheckCategory _category = HomeCheckCategory.other;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Yeni Kontrol Ekle', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Kontrol Adi', hintText: 'Ornegin: Balkon kapisini kapat', prefixIcon: Icon(Icons.edit)), textCapitalization: TextCapitalization.sentences),
            const SizedBox(height: 16),
            DropdownButtonFormField<HomeCheckCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Kategori', prefixIcon: Icon(Icons.category)),
              items: HomeCheckCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _addCheck, icon: const Icon(Icons.add), label: const Text('Ekle'))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addCheck() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lutfen kontrol adi girin')));
      return;
    }
    HapticFeedback.heavyImpact();
    context.read<AppProvider>().addCustomCheck(HomeCheck(id: '', name: name, category: _category));
    Navigator.pop(context);
  }
}
'''

def get_item_tile_dart():
    return r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/app_provider.dart';

class ItemTile extends StatelessWidget {
  final TripItem item;
  final String tripId;
  const ItemTile({super.key, required this.item, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Checkbox(
        value: item.isPacked,
        onChanged: (_) {
          HapticFeedback.selectionClick();
          context.read<AppProvider>().toggleItemPacked(tripId, item.itemId);
        },
      ),
      title: Text(
        item.name,
        style: TextStyle(
          decoration: item.isPacked ? TextDecoration.lineThrough : null,
          color: item.isPacked ? theme.colorScheme.onSurface.withValues(alpha: 0.5) : null,
        ),
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<AppProvider>().toggleItemPacked(tripId, item.itemId);
      },
    );
  }
}
'''

def get_category_section_dart():
    return r'''import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import 'item_tile.dart';

class CategorySection extends StatelessWidget {
  final ItemCategory category;
  final List<dynamic> items;
  final String tripId;
  const CategorySection({super.key, required this.category, required this.items, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripItems = items.cast<TripItem>();
    final packedCount = tripItems.where((i) => i.isPacked).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(category.iconData, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(category.label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: packedCount == items.length ? Colors.green : theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('$packedCount/${items.length}', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          ...tripItems.map((item) => ItemTile(item: item, tripId: tripId)),
        ],
      ),
    );
  }
}
'''

def get_countdown_widget_dart():
    return r'''import 'dart:async';
import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final DateTime targetDate;
  const CountdownWidget({super.key, required this.targetDate});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _calculateRemaining());
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    if (widget.targetDate.isAfter(now)) {
      setState(() => _remaining = widget.targetDate.difference(now));
    } else {
      setState(() => _remaining = Duration.zero);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_remaining == Duration.zero) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
        child: const Text('Seyahat basladi!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: theme.colorScheme.onTertiaryContainer),
          const SizedBox(width: 6),
          Text(
            days > 0 ? '$days gun $hours saat kaldi' : '$hours saat kaldi',
            style: TextStyle(color: theme.colorScheme.onTertiaryContainer, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
'''

def get_app_theme_dart():
    return r'''import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0), brightness: Brightness.light);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(centerTitle: true, backgroundColor: colorScheme.surface, foregroundColor: colorScheme.onSurface, elevation: 0, scrolledUnderElevation: 1),
      cardTheme: CardThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: colorScheme.outlineVariant))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.primary, width: 2)),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: colorScheme.primaryContainer, foregroundColor: colorScheme.onPrimaryContainer, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0), brightness: Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(centerTitle: true, backgroundColor: colorScheme.surface, foregroundColor: colorScheme.onSurface, elevation: 0, scrolledUnderElevation: 1),
      cardTheme: CardThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: colorScheme.outlineVariant))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.primary, width: 2)),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: colorScheme.primaryContainer, foregroundColor: colorScheme.onPrimaryContainer, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }
}
'''

if __name__ == "__main__":
    create_project()