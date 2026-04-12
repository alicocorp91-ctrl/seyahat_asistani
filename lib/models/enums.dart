import 'package:flutter/material.dart';

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

  Color get color {
    switch (this) {
      case Gender.male: return Colors.blueAccent;
      case Gender.female: return Colors.pinkAccent;
      case Gender.couple: return Colors.orangeAccent;
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

  Color get color {
    switch (this) {
      case Season.spring: return Colors.greenAccent;
      case Season.summer: return Colors.orange;
      case Season.autumn: return Colors.brown;
      case Season.winter: return Colors.lightBlueAccent;
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

  Color get color {
    switch (this) {
      case Transport.plane: return Colors.cyanAccent;
      case Transport.car: return Colors.redAccent;
      case Transport.bus: return Colors.yellowAccent;
      case Transport.train: return Colors.greenAccent;
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
      case ItemCategory.clothingBasic: return 'Kiyafet';
      case ItemCategory.clothingMale: return 'Erkek Giyim';
      case ItemCategory.clothingFemale: return 'Kadin Giyim';
      case ItemCategory.clothingWinter: return 'Kis Giyim';
      case ItemCategory.clothingSummer: return 'Yaz Giyim';
      case ItemCategory.personalCare: return 'Hijyen';
      case ItemCategory.personalCareMale: return 'Erkek Bakim';
      case ItemCategory.personalCareFemale: return 'Kadin Bakim';
      case ItemCategory.health: return 'Saglik';
      case ItemCategory.electronics: return 'Elektronik';
      case ItemCategory.documents: return 'Belgeler';
      case ItemCategory.documentsIntl: return 'Yurtdisi Belgeleri';
      case ItemCategory.intimate: return 'Ozel';
      case ItemCategory.transport: return 'Aksesuar';
      case ItemCategory.practical: return 'Pratik Esyalar';
      case ItemCategory.other: return 'Diger';
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
      default:
        return Colors.grey;
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

  Color get color {
    switch (this) {
      case HomeCheckCategory.electric: return Colors.amber;
      case HomeCheckCategory.waterGas: return Colors.blueAccent;
      case HomeCheckCategory.kitchen: return Colors.orangeAccent;
      case HomeCheckCategory.security: return Colors.redAccent;
      default: return Colors.grey;
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

enum PreTripPreparationCategory {
  personalCare,
  finance,
  electronics,
  shopping,
  travelPrep;

  String get label {
    switch (this) {
      case PreTripPreparationCategory.personalCare: return 'Kişisel Bakım';
      case PreTripPreparationCategory.finance: return 'Finans';
      case PreTripPreparationCategory.electronics: return 'Elektronik';
      case PreTripPreparationCategory.shopping: return 'Alışveriş';
      case PreTripPreparationCategory.travelPrep: return 'Seyahat Hazırlığı';
    }
  }

  Color get color {
    switch (this) {
      case PreTripPreparationCategory.personalCare: return Colors.pinkAccent;
      case PreTripPreparationCategory.finance: return Colors.greenAccent;
      case PreTripPreparationCategory.electronics: return Colors.blueAccent;
      case PreTripPreparationCategory.shopping: return Colors.orangeAccent;
      case PreTripPreparationCategory.travelPrep: return Colors.purpleAccent;
    }
  }

  IconData get iconData {
    switch (this) {
      case PreTripPreparationCategory.personalCare: return Icons.face;
      case PreTripPreparationCategory.finance: return Icons.account_balance_wallet;
      case PreTripPreparationCategory.electronics: return Icons.battery_charging_full;
      case PreTripPreparationCategory.shopping: return Icons.shopping_cart;
      case PreTripPreparationCategory.travelPrep: return Icons.map;
    }
  }
}
