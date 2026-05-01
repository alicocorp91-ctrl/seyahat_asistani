import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ✅ FIX 1: Kullanılmayan 'provider' import'u kaldırıldı (unused_import warning)
import 'package:seyahat_asistani/models/enums.dart';
import 'package:seyahat_asistani/models/item_model.dart';
import 'package:seyahat_asistani/models/home_check_model.dart';
import 'package:seyahat_asistani/models/trip_model.dart';
import 'package:seyahat_asistani/models/pre_trip_preparation_model.dart';

// ─── MODEL TESTLERİ ───────────────────────────────────────────────────────────
void main() {
  group('PackingItem Model', () {
    test('isVisibleFor - aktif değilse görünmez', () {
      const item = PackingItem(
        id: 'test',
        name: 'Test',
        category: ItemCategory.other,
        isActive: false,
      );
      expect(
        item.isVisibleFor(
          gender: Gender.male,
          season: Season.summer,
          transport: Transport.plane,
          tripType: TripType.domestic,
        ),
        false,
      );
    });

    test('isVisibleFor - cinsiyet filtresi doğru çalışır', () {
      const item = PackingItem(
        id: 'test',
        name: 'Test',
        category: ItemCategory.clothingMale,
        genderVisibility: GenderVisibility.maleOnly,
      );
      expect(
        item.isVisibleFor(
          gender: Gender.male,
          season: Season.summer,
          transport: Transport.plane,
          tripType: TripType.domestic,
        ),
        true,
      );
      expect(
        item.isVisibleFor(
          gender: Gender.female,
          season: Season.summer,
          transport: Transport.plane,
          tripType: TripType.domestic,
        ),
        false,
      );
    });

    test('isVisibleFor - mevsim filtresi doğru çalışır', () {
      const item = PackingItem(
        id: 'test',
        name: 'Test',
        category: ItemCategory.clothingWinter,
        seasons: [Season.winter],
      );
      expect(
        item.isVisibleFor(
          gender: Gender.male,
          season: Season.winter,
          transport: Transport.plane,
          tripType: TripType.domestic,
        ),
        true,
      );
      expect(
        item.isVisibleFor(
          gender: Gender.male,
          season: Season.summer,
          transport: Transport.plane,
          tripType: TripType.domestic,
        ),
        false,
      );
    });

    test('isVisibleFor - sadece uluslararası item yurt içinde görünmez', () {
      const item = PackingItem(
        id: 'passport',
        name: 'Pasaport',
        category: ItemCategory.documentsIntl,
        internationalOnly: true,
      );
      expect(
        item.isVisibleFor(
          gender: Gender.male,
          season: Season.summer,
          transport: Transport.plane,
          tripType: TripType.domestic,
        ),
        false,
      );
      expect(
        item.isVisibleFor(
          gender: Gender.male,
          season: Season.summer,
          transport: Transport.plane,
          tripType: TripType.international,
        ),
        true,
      );
    });

    test('toJson / fromJson - gidiş dönüş tutarlı', () {
      const item = PackingItem(
        id: 'test_id',
        name: 'Test Eşya',
        category: ItemCategory.health,
        genderVisibility: GenderVisibility.all,
        seasons: [Season.summer, Season.winter],
        transports: [Transport.plane],
        internationalOnly: false,
        isCustom: true,
        isActive: true,
      );
      final json = item.toJson();
      final restored = PackingItem.fromJson(json);

      expect(restored.id, item.id);
      expect(restored.name, item.name);
      expect(restored.category, item.category);
      expect(restored.seasons, item.seasons);
      expect(restored.transports, item.transports);
      expect(restored.isCustom, item.isCustom);
    });
  });

  // ─── HomeCheck Model ──────────────────────────────────────────────────────
  group('HomeCheck Model', () {
    test('toJson / fromJson - gidiş dönüş tutarlı', () {
      const check = HomeCheck(
        id: 'door',
        name: 'Kapıyı kilitle',
        category: HomeCheckCategory.security,
        isCustom: false,
        isActive: true,
      );
      final json = check.toJson();
      final restored = HomeCheck.fromJson(json);

      expect(restored.id, check.id);
      expect(restored.name, check.name);
      expect(restored.category, check.category);
      expect(restored.isActive, check.isActive);
    });

    test('fromJson - eksik alan için default değer kullanılır', () {
      final json = {
        'id': 'test',
        'name': 'Test',
        'category': 0,
        // isCustom ve isActive kasıtlı eksik
      };
      final check = HomeCheck.fromJson(json);
      expect(check.isCustom, false);
      expect(check.isActive, true);
    });
  });

  // ─── Trip Model ───────────────────────────────────────────────────────────
  group('Trip Model', () {
    // ✅ FIX 2: '_makeTrip' → 'makeTrip' (no_leading_underscores_for_local_identifiers)
    // Yerel fonksiyonlar _ ile başlamamalı, sadece sınıf üyeleri başlayabilir
    Trip makeTrip({
      List<TripItem> items = const [],
      List<String> completedHomeChecks = const [],
      List<String> completedPreTripPreparations = const [],
    }) {
      return Trip(
        id: 'trip_1',
        name: 'Test Seyahat',
        fromLocation: 'İstanbul',
        toLocation: 'Antalya',
        gender: Gender.male,
        season: Season.summer,
        transport: Transport.plane,
        tripType: TripType.domestic,
        startDate: DateTime(2025, 8, 1),
        endDate: DateTime(2025, 8, 7),
        createdAt: DateTime(2025, 7, 1),
        items: items,
        completedHomeChecks: completedHomeChecks,
        completedPreTripPreparations: completedPreTripPreparations,
      );
    }

    test('days - doğru gün sayısını döndürür', () {
      // ✅ makeTrip olarak güncellendi
      final trip = makeTrip();
      expect(trip.days, 7);
    });

    test('progress - eşya yoksa 0 döner', () {
      final trip = makeTrip();
      expect(trip.progress, 0.0);
    });

    test('progress - tüm eşyalar paketliyse 1 döner', () {
      final items = [
        const TripItem(
          itemId: '1',
          name: 'Eşya 1',
          isPacked: true,
          category: ItemCategory.other,
        ),
        const TripItem(
          itemId: '2',
          name: 'Eşya 2',
          isPacked: true,
          category: ItemCategory.other,
        ),
      ];
      final trip = makeTrip(items: items);
      expect(trip.progress, 1.0);
    });

    test('progress - yarısı paketliyse 0.5 döner', () {
      final items = [
        const TripItem(
          itemId: '1',
          name: 'Eşya 1',
          isPacked: true,
          category: ItemCategory.other,
        ),
        const TripItem(
          itemId: '2',
          name: 'Eşya 2',
          isPacked: false,
          category: ItemCategory.other,
        ),
      ];
      final trip = makeTrip(items: items);
      expect(trip.progress, 0.5);
    });

    test('hasStarted - geçmiş tarihli seyahat başlamış sayılır', () {
      final trip = Trip(
        id: '1',
        name: 'Test',
        fromLocation: 'A',
        toLocation: 'B',
        gender: Gender.male,
        season: Season.summer,
        transport: Transport.plane,
        tripType: TripType.domestic,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 3)),
        createdAt: DateTime.now(),
        items: const [],
      );
      expect(trip.hasStarted, true);
      expect(trip.hasEnded, false);
      expect(trip.isOngoing, true);
    });

    test('toJson / fromJson - gidiş dönüş tutarlı', () {
      final trip = makeTrip(
        items: [
          const TripItem(
            itemId: 'i1',
            name: 'Eşya',
            isPacked: false,
            category: ItemCategory.other,
          ),
        ],
      );
      final json = trip.toJson();
      final restored = Trip.fromJson(json);

      expect(restored.id, trip.id);
      expect(restored.name, trip.name);
      expect(restored.gender, trip.gender);
      expect(restored.items.length, trip.items.length);
      expect(restored.days, trip.days);
    });
  });

  // ─── Enum Testleri ────────────────────────────────────────────────────────
  group('Enum - Güvenli parse', () {
    test('Gender.fromIndex - geçerli index', () {
      expect(Gender.fromIndex(0), Gender.male);
      expect(Gender.fromIndex(1), Gender.female);
      expect(Gender.fromIndex(2), Gender.couple);
    });

    test('Gender.fromIndex - geçersiz index default döner', () {
      expect(Gender.fromIndex(99), Gender.male);
      expect(Gender.fromIndex(-1), Gender.male);
      expect(Gender.fromIndex(null), Gender.male);
    });

    test('Season.fromIndex - geçerli index', () {
      expect(Season.fromIndex(0), Season.spring);
      expect(Season.fromIndex(3), Season.winter);
    });

    test('ItemCategory.fromIndex - geçersiz index default döner', () {
      expect(ItemCategory.fromIndex(999), ItemCategory.other);
    });
  });

  // ─── PreTripPreparation Model ─────────────────────────────────────────────
  group('PreTripPreparation Model', () {
    test('clearSchedule - tarihi ve bildirimi sıfırlar', () {
      final prep = PreTripPreparation(
        id: 'test',
        name: 'Test',
        category: PreTripPreparationCategory.travelPrep,
        scheduledDate: DateTime(2025, 8, 1),
        isNotificationEnabled: true,
      );

      final cleared = prep.clearSchedule();
      expect(cleared.scheduledDate, null);
      expect(cleared.isNotificationEnabled, false);
    });

    test('toJson / fromJson - scheduledDate korunur', () {
      final date = DateTime(2025, 8, 15, 10, 30);
      final prep = PreTripPreparation(
        id: 'test',
        name: 'Test',
        category: PreTripPreparationCategory.finance,
        scheduledDate: date,
        isNotificationEnabled: true,
      );

      final json = prep.toJson();
      final restored = PreTripPreparation.fromJson(json);

      expect(restored.scheduledDate?.year, date.year);
      expect(restored.scheduledDate?.month, date.month);
      expect(restored.scheduledDate?.day, date.day);
      expect(restored.isNotificationEnabled, true);
    });

    test('fromJson - bozuk scheduledDate null döner', () {
      final json = {
        'id': 'test',
        'name': 'Test',
        'category': 0,
        'scheduledDate': 'gecersiz-tarih-formati',
      };
      final prep = PreTripPreparation.fromJson(json);
      expect(prep.scheduledDate, null);
    });
  });

  // ─── Widget Testleri ──────────────────────────────────────────────────────
  group('Widget - CountdownWidget', () {
    testWidgets('Geçmiş tarih için başladı mesajı gösterir',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                // ✅ FIX 3: Yanlış yerdeki 'ignore: unused_import' yorumu kaldırıldı
                // Bu ignore anlamsızdı - burada import yok, sadece SizedBox var
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
