import 'package:flutter/material.dart';

// ✅ Güvenli enum parse yardımcısı - index OOB crash önler
T _safeEnumParse<T>(List<T> values, int? index, T defaultValue) {
  if (index == null || index < 0 || index >= values.length) {
    debugPrint('⚠️ Geçersiz enum index: $index, default kullanılıyor');
    return defaultValue;
  }
  return values[index];
}

// ─── Gender ───────────────────────────────────────────────────────────────────
enum Gender {
  male,
  female,
  couple;

  String get label {
    switch (this) {
      case Gender.male:
        return 'Erkek';
      case Gender.female:
        return 'Kadın'; // ✅ Türkçe
      case Gender.couple:
        return 'Çift'; // ✅ Türkçe
    }
  }

  Color get color {
    switch (this) {
      case Gender.male:
        return Colors.blueAccent;
      case Gender.female:
        return Colors.pinkAccent;
      case Gender.couple:
        return Colors.orangeAccent;
    }
  }

  IconData get iconData {
    switch (this) {
      case Gender.male:
        return Icons.man;
      case Gender.female:
        return Icons.woman;
      case Gender.couple:
        return Icons.people;
    }
  }

  // ✅ Güvenli JSON parse
  static Gender fromIndex(int? index) =>
      _safeEnumParse(Gender.values, index, Gender.male);
}

// ─── Season ───────────────────────────────────────────────────────────────────
enum Season {
  spring,
  summer,
  autumn,
  winter;

  String get label {
    switch (this) {
      case Season.spring:
        return 'İlkbahar'; // ✅
      case Season.summer:
        return 'Yaz';
      case Season.autumn:
        return 'Sonbahar';
      case Season.winter:
        return 'Kış'; // ✅
    }
  }

  Color get color {
    switch (this) {
      case Season.spring:
        return Colors.greenAccent;
      case Season.summer:
        return Colors.orange;
      case Season.autumn:
        return Colors.brown;
      case Season.winter:
        return Colors.lightBlueAccent;
    }
  }

  IconData get iconData {
    switch (this) {
      case Season.spring:
        return Icons.local_florist;
      case Season.summer:
        return Icons.wb_sunny;
      case Season.autumn:
        return Icons.eco;
      case Season.winter:
        return Icons.ac_unit;
    }
  }

  static Season fromIndex(int? index) =>
      _safeEnumParse(Season.values, index, Season.summer);
}

// ─── Transport ────────────────────────────────────────────────────────────────
enum Transport {
  plane,
  car,
  bus,
  train;

  String get label {
    switch (this) {
      case Transport.plane:
        return 'Uçak'; // ✅
      case Transport.car:
        return 'Araba';
      case Transport.bus:
        return 'Otobüs'; // ✅
      case Transport.train:
        return 'Tren';
    }
  }

  Color get color {
    switch (this) {
      case Transport.plane:
        return Colors.cyanAccent;
      case Transport.car:
        return Colors.redAccent;
      case Transport.bus:
        return Colors.yellowAccent;
      case Transport.train:
        return Colors.greenAccent;
    }
  }

  IconData get iconData {
    switch (this) {
      case Transport.plane:
        return Icons.flight;
      case Transport.car:
        return Icons.directions_car;
      case Transport.bus:
        return Icons.directions_bus;
      case Transport.train:
        return Icons.train;
    }
  }

  static Transport fromIndex(int? index) =>
      _safeEnumParse(Transport.values, index, Transport.plane);
}

// ─── TripType ─────────────────────────────────────────────────────────────────
enum TripType {
  domestic,
  international;

  String get label {
    switch (this) {
      case TripType.domestic:
        return 'Yurt İçi'; // ✅
      case TripType.international:
        return 'Yurt Dışı'; // ✅
    }
  }

  IconData get iconData {
    switch (this) {
      case TripType.domestic:
        return Icons.home;
      case TripType.international:
        return Icons.public;
    }
  }

  // ✅ Renk eklendi - tutarlılık için
  Color get color {
    switch (this) {
      case TripType.domestic:
        return Colors.teal;
      case TripType.international:
        return Colors.deepPurpleAccent;
    }
  }

  static TripType fromIndex(int? index) =>
      _safeEnumParse(TripType.values, index, TripType.domestic);
}

// ─── GenderVisibility ─────────────────────────────────────────────────────────
enum GenderVisibility {
  all,
  maleOnly,
  femaleOnly,
  coupleOnly,
  maleAndCouple,
  femaleAndCouple;

  bool isVisibleFor(Gender gender) {
    switch (this) {
      case GenderVisibility.all:
        return true;
      case GenderVisibility.maleOnly:
        return gender == Gender.male;
      case GenderVisibility.femaleOnly:
        return gender == Gender.female;
      case GenderVisibility.coupleOnly:
        return gender == Gender.couple;
      case GenderVisibility.maleAndCouple:
        return gender == Gender.male || gender == Gender.couple;
      case GenderVisibility.femaleAndCouple:
        return gender == Gender.female || gender == Gender.couple;
    }
  }

  String get label {
    switch (this) {
      case GenderVisibility.all:
        return 'Herkes';
      case GenderVisibility.maleOnly:
        return 'Sadece Erkek';
      case GenderVisibility.femaleOnly:
        return 'Sadece Kadın'; // ✅
      case GenderVisibility.coupleOnly:
        return 'Sadece Çift'; // ✅
      case GenderVisibility.maleAndCouple:
        return 'Erkek ve Çift'; // ✅
      case GenderVisibility.femaleAndCouple:
        return 'Kadın ve Çift'; // ✅
    }
  }

  static GenderVisibility fromIndex(int? index) =>
      _safeEnumParse(GenderVisibility.values, index, GenderVisibility.all);
}

// ─── ItemCategory ─────────────────────────────────────────────────────────────
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
      case ItemCategory.clothingBasic:
        return 'Kıyafet'; // ✅
      case ItemCategory.clothingMale:
        return 'Erkek Giyim';
      case ItemCategory.clothingFemale:
        return 'Kadın Giyim'; // ✅
      case ItemCategory.clothingWinter:
        return 'Kış Giyim'; // ✅
      case ItemCategory.clothingSummer:
        return 'Yaz Giyim';
      case ItemCategory.personalCare:
        return 'Hijyen';
      case ItemCategory.personalCareMale:
        return 'Erkek Bakım'; // ✅
      case ItemCategory.personalCareFemale:
        return 'Kadın Bakım'; // ✅
      case ItemCategory.health:
        return 'Sağlık'; // ✅
      case ItemCategory.electronics:
        return 'Elektronik';
      case ItemCategory.documents:
        return 'Belgeler';
      case ItemCategory.documentsIntl:
        return 'Yurt Dışı Belgeleri'; // ✅
      case ItemCategory.intimate:
        return 'Özel'; // ✅
      case ItemCategory.transport:
        return 'Aksesuar';
      case ItemCategory.practical:
        return 'Pratik Eşyalar'; // ✅
      case ItemCategory.other:
        return 'Diğer'; // ✅
    }
  }

  Color get color {
    switch (this) {
      case ItemCategory.documents:
      case ItemCategory.documentsIntl:
        return Colors.redAccent;

      case ItemCategory.transport:
      case ItemCategory.practical:
        return Colors.purpleAccent;

      case ItemCategory.electronics:
        return Colors.amber;

      case ItemCategory.clothingBasic:
      case ItemCategory.clothingMale:
      case ItemCategory.clothingFemale:
      case ItemCategory.clothingWinter:
      case ItemCategory.clothingSummer:
        return Colors.blueAccent;

      case ItemCategory.personalCare:
      case ItemCategory.personalCareMale:
      case ItemCategory.personalCareFemale:
      case ItemCategory.health:
        return Colors.greenAccent;

      case ItemCategory.intimate:
        return Colors.deepPurpleAccent; // ✅ Artık grey değil

      case ItemCategory.other:
        return Colors.grey;
    }
  }

  IconData get iconData {
    switch (this) {
      case ItemCategory.clothingBasic:
        return Icons.checkroom;
      case ItemCategory.clothingMale:
        return Icons.man;
      case ItemCategory.clothingFemale:
        return Icons.woman;
      case ItemCategory.clothingWinter:
        return Icons.ac_unit;
      case ItemCategory.clothingSummer:
        return Icons.wb_sunny;
      case ItemCategory.personalCare:
        return Icons.soap;
      case ItemCategory.personalCareMale:
        return Icons.face;
      case ItemCategory.personalCareFemale:
        return Icons.face_3;
      case ItemCategory.health:
        return Icons.medical_services;
      case ItemCategory.electronics:
        return Icons.devices;
      case ItemCategory.documents:
        return Icons.description;
      case ItemCategory.documentsIntl:
        return Icons.public;
      case ItemCategory.intimate:
        return Icons.lock;
      case ItemCategory.transport:
        return Icons.commute;
      case ItemCategory.practical:
        return Icons.handyman;
      case ItemCategory.other:
        return Icons.category;
    }
  }

  static ItemCategory fromIndex(int? index) =>
      _safeEnumParse(ItemCategory.values, index, ItemCategory.other);
}

// ─── HomeCheckCategory ────────────────────────────────────────────────────────
enum HomeCheckCategory {
  electric,
  waterGas,
  kitchen,
  security,
  other;

  String get label {
    switch (this) {
      case HomeCheckCategory.electric:
        return 'Elektrik';
      case HomeCheckCategory.waterGas:
        return 'Su ve Gaz';
      case HomeCheckCategory.kitchen:
        return 'Mutfak';
      case HomeCheckCategory.security:
        return 'Güvenlik'; // ✅
      case HomeCheckCategory.other:
        return 'Diğer'; // ✅
    }
  }

  Color get color {
    switch (this) {
      case HomeCheckCategory.electric:
        return Colors.amber;
      case HomeCheckCategory.waterGas:
        return Colors.blueAccent;
      case HomeCheckCategory.kitchen:
        return Colors.orangeAccent;
      case HomeCheckCategory.security:
        return Colors.redAccent;
      case HomeCheckCategory.other:
        return Colors.grey; // ✅ default kaldırıldı
    }
  }

  IconData get iconData {
    switch (this) {
      case HomeCheckCategory.electric:
        return Icons.electrical_services;
      case HomeCheckCategory.waterGas:
        return Icons.water_drop;
      case HomeCheckCategory.kitchen:
        return Icons.kitchen;
      case HomeCheckCategory.security:
        return Icons.security;
      case HomeCheckCategory.other:
        return Icons.more_horiz;
    }
  }

  static HomeCheckCategory fromIndex(int? index) =>
      _safeEnumParse(HomeCheckCategory.values, index, HomeCheckCategory.other);
}

// ─── PreTripPreparationCategory ───────────────────────────────────────────────
enum PreTripPreparationCategory {
  personalCare,
  finance,
  electronics,
  shopping,
  travelPrep;

  String get label {
    switch (this) {
      case PreTripPreparationCategory.personalCare:
        return 'Kişisel Bakım';
      case PreTripPreparationCategory.finance:
        return 'Finans';
      case PreTripPreparationCategory.electronics:
        return 'Elektronik';
      case PreTripPreparationCategory.shopping:
        return 'Alışveriş';
      case PreTripPreparationCategory.travelPrep:
        return 'Seyahat Hazırlığı';
    }
  }

  Color get color {
    switch (this) {
      case PreTripPreparationCategory.personalCare:
        return Colors.pinkAccent;
      case PreTripPreparationCategory.finance:
        return Colors.greenAccent;
      case PreTripPreparationCategory.electronics:
        return Colors.blueAccent;
      case PreTripPreparationCategory.shopping:
        return Colors.orangeAccent;
      case PreTripPreparationCategory.travelPrep:
        return Colors.purpleAccent;
    }
  }

  IconData get iconData {
    switch (this) {
      case PreTripPreparationCategory.personalCare:
        return Icons.face;
      case PreTripPreparationCategory.finance:
        return Icons.account_balance_wallet;
      case PreTripPreparationCategory.electronics:
        return Icons.battery_charging_full;
      case PreTripPreparationCategory.shopping:
        return Icons.shopping_cart;
      case PreTripPreparationCategory.travelPrep:
        return Icons.map;
    }
  }

  static PreTripPreparationCategory fromIndex(int? index) => _safeEnumParse(
        PreTripPreparationCategory.values,
        index,
        PreTripPreparationCategory.travelPrep,
      );
}
