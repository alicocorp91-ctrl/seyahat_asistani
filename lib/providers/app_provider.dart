import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../models/trip_model.dart';
import '../models/home_check_model.dart';
import '../models/pre_trip_preparation_model.dart';
import '../data/default_items.dart';
import '../data/default_home_checks.dart';
import '../data/default_pre_trip_preparations.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';

class AppProvider extends ChangeNotifier {
  // ─── State ────────────────────────────────────────────────────────────────
  List<PackingItem> _allItems = [];
  List<HomeCheck> _allHomeChecks = [];
  List<PreTripPreparation> _allPreTripPreparations = [];
  List<Trip> _trips = [];

  Map<String, bool> _itemActiveStatus = {};
  Map<String, bool> _checkActiveStatus = {};
  Map<String, bool> _preparationActiveStatus = {};

  bool _isLoading = true;
  String? _error;
  AppThemeMode _currentTheme = AppThemeMode.classicDark;

  // ─── Getters ──────────────────────────────────────────────────────────────
  List<PackingItem> get allItems => List.unmodifiable(_allItems);
  List<HomeCheck> get allHomeChecks => List.unmodifiable(_allHomeChecks);
  List<PreTripPreparation> get allPreTripPreparations =>
      List.unmodifiable(_allPreTripPreparations);
  List<Trip> get trips => List.unmodifiable(_trips);
  bool get isLoading => _isLoading;
  String? get error => _error;
  AppThemeMode get currentTheme => _currentTheme;
  bool get hasError => _error != null;

  // ─── Services ─────────────────────────────────────────────────────────────
  final _uuid = const Uuid();
  final _notificationService = NotificationService();
  SharedPreferences? _prefs;

  // ─── SharedPreferences Key Sabitleri ──────────────────────────────────────
  static const String _keyThemeIndex = 'app_theme_index';
  static const String _keyItemStatus = 'item_status';
  static const String _keyCheckStatus = 'check_status';
  static const String _keyPreparationStatus = 'preparation_status';
  static const String _keyCustomItems = 'custom_items';
  static const String _keyCustomChecks = 'custom_checks';
  static const String _keyCustomPreparations = 'custom_preparations';
  static const String _keyTrips = 'trips';

  // ✅ YENİ: İlk kurulum key'i
  static const String _keyIsFirstLaunch = 'is_first_launch';

  // ─── Init ─────────────────────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _prefs = await SharedPreferences.getInstance();

      // ✅ YENİ: İlk kurulum kontrolü
      final isFirstLaunch = _prefs!.getBool(_keyIsFirstLaunch) ?? true;

      if (isFirstLaunch) {
        // İlk açılışta yalnızca kurulum işaretini yaz. Eski sürümden
        // gelen verileri silmek kullanıcı seyahatlerini kaybetmesine yol açar.
        await _prefs!.setBool(_keyIsFirstLaunch, false);
        debugPrint('✅ İlk kurulum tamamlandı');
      }

      await _loadAllData();
    } catch (e, stack) {
      _error = 'Veriler yüklenirken hata oluştu';
      debugPrint('❌ AppProvider init hatası: $e');
      debugPrint('Stack: $stack');
      _loadDefaults();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Default değerleri yükle (hata durumunda)
  void _loadDefaults() {
    _allItems = defaultPackingItems.toList();
    _allHomeChecks = defaultHomeChecks.toList();
    _allPreTripPreparations = defaultPreTripPreparations.toList();
    _trips = [];
    _currentTheme = AppThemeMode.classicDark;
  }

  /// Tüm verileri yükle
  Future<void> _loadAllData() async {
    final prefs = _prefs!;

    // ── Tema ──────────────────────────────────────────────────────────────
    final themeIndex = prefs.getInt(_keyThemeIndex) ?? 0;
    _currentTheme = (themeIndex >= 0 && themeIndex < AppThemeMode.values.length)
        ? AppThemeMode.values[themeIndex]
        : AppThemeMode.classicDark;

    // ── Aktiflik Durumları ────────────────────────────────────────────────
    _itemActiveStatus = _loadBoolMap(prefs, _keyItemStatus);
    _checkActiveStatus = _loadBoolMap(prefs, _keyCheckStatus);
    _preparationActiveStatus = _loadBoolMap(prefs, _keyPreparationStatus);

    // ── Items ─────────────────────────────────────────────────────────────
    final customItems = _loadList<PackingItem>(
      prefs,
      _keyCustomItems,
      PackingItem.fromJson,
    );

    _allItems = [
      ...defaultPackingItems.map(
        (item) => item.copyWith(
          isActive: _itemActiveStatus[item.id] ?? item.isActive,
        ),
      ),
      ...customItems,
    ];

    // ── Home Checks ───────────────────────────────────────────────────────
    final customChecks = _loadList<HomeCheck>(
      prefs,
      _keyCustomChecks,
      HomeCheck.fromJson,
    );

    _allHomeChecks = [
      ...defaultHomeChecks.map(
        (check) => check.copyWith(
          isActive: _checkActiveStatus[check.id] ?? check.isActive,
        ),
      ),
      ...customChecks,
    ];

    // ── Pre Trip Preparations ─────────────────────────────────────────────
    final customPreps = _loadList<PreTripPreparation>(
      prefs,
      _keyCustomPreparations,
      PreTripPreparation.fromJson,
    );

    _allPreTripPreparations = [
      ...defaultPreTripPreparations.map(
        (prep) => prep.copyWith(
          isActive: _preparationActiveStatus[prep.id] ?? prep.isActive,
        ),
      ),
      ...customPreps,
    ];

    // ── Trips ─────────────────────────────────────────────────────────────
    // ✅ İlk kurulumda _keyTrips zaten silindi, boş liste gelir
    _trips = _loadList<Trip>(prefs, _keyTrips, Trip.fromJson);
  }

  // ─── Yardımcı: Güvenli JSON list yükleme ──────────────────────────────────
  List<T> _loadList<T>(
    SharedPreferences prefs,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final jsonStr = prefs.getString(key);
      if (jsonStr == null) return [];

      final decoded = jsonDecode(jsonStr);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((e) {
            try {
              return fromJson(e);
            } catch (e) {
              debugPrint('⚠️ JSON parse hatası ($key): $e');
              return null;
            }
          })
          .whereType<T>()
          .toList();
    } catch (e) {
      debugPrint('⚠️ Liste yükleme hatası ($key): $e');
      return [];
    }
  }

  // ─── Yardımcı: Güvenli bool map yükleme ───────────────────────────────────
  Map<String, bool> _loadBoolMap(SharedPreferences prefs, String key) {
    try {
      final jsonStr = prefs.getString(key);
      if (jsonStr == null) return {};
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map) return {};
      return decoded.map(
        (k, v) => MapEntry(k.toString(), v == true),
      );
    } catch (e) {
      debugPrint('⚠️ Bool map yükleme hatası ($key): $e');
      return {};
    }
  }

  // ─── Save Yardımcıları ────────────────────────────────────────────────────
  Future<void> _saveTrips() async {
    await _saveJson(
      _keyTrips,
      _trips.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> _saveItemStatus() async {
    await _saveJson(_keyItemStatus, _itemActiveStatus);
  }

  Future<void> _saveCheckStatus() async {
    await _saveJson(_keyCheckStatus, _checkActiveStatus);
  }

  Future<void> _savePreparationStatus() async {
    await _saveJson(_keyPreparationStatus, _preparationActiveStatus);
  }

  Future<void> _saveCustomItems() async {
    final customItems = _allItems.where((i) => i.isCustom).toList();
    await _saveJson(
      _keyCustomItems,
      customItems.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> _saveCustomChecks() async {
    final customChecks = _allHomeChecks.where((c) => c.isCustom).toList();
    await _saveJson(
      _keyCustomChecks,
      customChecks.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> _saveCustomPreparations() async {
    final customPreps =
        _allPreTripPreparations.where((p) => p.isCustom).toList();
    await _saveJson(
      _keyCustomPreparations,
      customPreps.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> _saveJson(String key, dynamic data) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString(key, jsonEncode(data));
    } catch (e) {
      debugPrint('❌ Kaydetme hatası ($key): $e');
    }
  }

  // ─── Tema ─────────────────────────────────────────────────────────────────
  Future<void> setTheme(AppThemeMode mode) async {
    _currentTheme = mode;
    notifyListeners();
    await _saveJson(_keyThemeIndex, mode.index);
  }

  // ─── Item Toggle ──────────────────────────────────────────────────────────
  Future<void> toggleItemActive(String id) async {
    final index = _allItems.indexWhere((i) => i.id == id);
    if (index == -1) return;

    final item = _allItems[index];
    _allItems[index] = item.copyWith(isActive: !item.isActive);
    _itemActiveStatus[id] = _allItems[index].isActive;

    notifyListeners();

    await Future.wait([
      _saveItemStatus(),
      if (item.isCustom) _saveCustomItems(),
    ]);
  }

  Future<void> toggleCheckActive(String id) async {
    final index = _allHomeChecks.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final check = _allHomeChecks[index];
    _allHomeChecks[index] = check.copyWith(isActive: !check.isActive);
    _checkActiveStatus[id] = _allHomeChecks[index].isActive;

    notifyListeners();

    await Future.wait([
      _saveCheckStatus(),
      if (check.isCustom) _saveCustomChecks(),
    ]);
  }

  Future<void> togglePreparationActive(String id) async {
    final index = _allPreTripPreparations.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final preparation = _allPreTripPreparations[index];
    _allPreTripPreparations[index] =
        preparation.copyWith(isActive: !preparation.isActive);
    _preparationActiveStatus[id] = _allPreTripPreparations[index].isActive;

    notifyListeners();

    await Future.wait([
      _savePreparationStatus(),
      if (preparation.isCustom) _saveCustomPreparations(),
    ]);
  }

  // ─── Trip Oluşturma ───────────────────────────────────────────────────────
  Future<Trip> createTrip({
    required String name,
    required String fromLocation,
    required String toLocation,
    required Gender gender,
    required Season season,
    required Transport transport,
    required TripType tripType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final cleanName = name.trim();
    final cleanFrom = fromLocation.trim();
    final cleanTo = toLocation.trim();
    if (cleanName.length < 2 || cleanFrom.isEmpty || cleanTo.isEmpty) {
      throw ArgumentError('Seyahat adı ve konumlar doldurulmalıdır.');
    }
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('Bitiş tarihi başlangıç tarihinden önce olamaz.');
    }

    final filteredItems = _allItems
        .where((item) => item.isVisibleFor(
              gender: gender,
              season: season,
              transport: transport,
              tripType: tripType,
            ))
        .toList();

    final tripItems = filteredItems
        .map((item) => TripItem(
              itemId: item.id,
              name: item.name,
              category: item.category,
            ))
        .toList();

    final tripHomeChecks = _allHomeChecks.where((c) => c.isActive).toList();

    final tripPreTripPreparations = _allPreTripPreparations
        .where((p) =>
            p.isActive &&
            (tripType == TripType.international || !p.isForInternational))
        .toList();

    final trip = Trip(
      id: _uuid.v4(),
      name: cleanName,
      fromLocation: cleanFrom,
      toLocation: cleanTo,
      gender: gender,
      season: season,
      transport: transport,
      tripType: tripType,
      startDate: startDate,
      endDate: endDate,
      createdAt: DateTime.now(),
      items: tripItems,
      homeChecks: tripHomeChecks,
      preTripPreparations: tripPreTripPreparations,
      completedHomeChecks: const [],
      completedPreTripPreparations: const [],
    );

    _trips.insert(0, trip);
    notifyListeners();

    await _saveTrips();

    // Seyahat oluşturulurken planlanmış hazırlık bildirimlerini de kur.
    // Böylece bildirimler yalnızca hazırlık ekranı açıldıktan sonra değil,
    // seyahat oluşturulduğu anda aktif olur.
    await Future.wait(
      trip.preTripPreparations
          .where((prep) =>
              prep.scheduledDate != null && prep.isNotificationEnabled &&
              !trip.completedPreTripPreparations.contains(prep.id))
          .map((prep) => _notificationService.scheduleNotification(
                id: (trip.id + prep.id).hashCode,
                title: 'Hazırlık Hatırlatıcısı',
                body: '${prep.name} zamanı geldi!',
                scheduledDate: prep.scheduledDate!,
                payload: trip.id,
              )),
    );
    return trip;
  }

  // ─── Trip Güncelleme ──────────────────────────────────────────────────────
  Future<void> updateTripInitialSelection(
    String tripId,
    List<TripItem> items,
    List<HomeCheck> checks,
    List<PreTripPreparation> preparations,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    _trips[index] = _trips[index].copyWith(
      items: items,
      homeChecks: checks,
      preTripPreparations: preparations,
    );

    notifyListeners();
    await _saveTrips();
  }

  Future<void> toggleItemPacked(String tripId, String itemId) async {
    final tripIndex = _trips.indexWhere((t) => t.id == tripId);
    if (tripIndex == -1) return;

    final trip = _trips[tripIndex];
    final itemIndex = trip.items.indexWhere((i) => i.itemId == itemId);
    if (itemIndex == -1) return;

    final updatedItems = List<TripItem>.from(trip.items);
    updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
      isPacked: !updatedItems[itemIndex].isPacked,
    );

    _trips[tripIndex] = trip.copyWith(items: updatedItems);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> removeItemFromTrip(String tripId, String itemId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final updatedItems = List<TripItem>.from(trip.items)
      ..removeWhere((i) => i.itemId == itemId);

    _trips[index] = trip.copyWith(items: updatedItems);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> addItemToTrip(
    String tripId,
    String name,
    ItemCategory category,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final newItem = TripItem(
      itemId: _uuid.v4(),
      name: name,
      category: category,
    );
    final updatedItems = List<TripItem>.from(trip.items)..add(newItem);

    _trips[index] = trip.copyWith(items: updatedItems);
    notifyListeners();
    await _saveTrips();
  }

  // ─── Pre Trip Preparations ────────────────────────────────────────────────
  Future<void> togglePreTripPreparation(String tripId, String prepId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final completed = List<String>.from(trip.completedPreTripPreparations);

    final bool isNowCompleted;
    if (completed.contains(prepId)) {
      completed.remove(prepId);
      isNowCompleted = false;
    } else {
      completed.add(prepId);
      isNowCompleted = true;
    }

    _trips[index] = trip.copyWith(completedPreTripPreparations: completed);
    notifyListeners();
    await _saveTrips();

    final prep = trip.preTripPreparations.firstWhereOrNull(
      (p) => p.id == prepId,
    );
    if (prep == null) return;

    final notifId = (tripId + prepId).hashCode;

    if (isNowCompleted) {
      await _notificationService.cancelNotification(notifId);
    } else if (prep.scheduledDate != null && prep.isNotificationEnabled) {
      await _notificationService.scheduleNotification(
        id: notifId,
        title: 'Hazırlık Hatırlatıcısı',
        body: '${prep.name} zamanı geldi!',
        scheduledDate: prep.scheduledDate!,
        payload: tripId,
      );
    }
  }

  Future<void> updatePreTripPreparation(
    String tripId,
    PreTripPreparation updatedPrep,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final updatedPreps =
        List<PreTripPreparation>.from(trip.preTripPreparations);
    final prepIndex = updatedPreps.indexWhere((p) => p.id == updatedPrep.id);
    if (prepIndex == -1) return;

    updatedPreps[prepIndex] = updatedPrep;
    _trips[index] = trip.copyWith(preTripPreparations: updatedPreps);
    notifyListeners();
    await _saveTrips();

    final notifId = (tripId + updatedPrep.id).hashCode;
    final isCompleted =
        trip.completedPreTripPreparations.contains(updatedPrep.id);

    if (!isCompleted &&
        updatedPrep.scheduledDate != null &&
        updatedPrep.isNotificationEnabled) {
      await _notificationService.scheduleNotification(
        id: notifId,
        title: 'Hazırlık Hatırlatıcısı',
        body: '${updatedPrep.name} zamanı geldi!',
        scheduledDate: updatedPrep.scheduledDate!,
        payload: tripId,
      );
    } else {
      await _notificationService.cancelNotification(notifId);
    }
  }

  Future<void> removePreTripPreparationFromTrip(
    String tripId,
    String prepId,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final updatedPreps = List<PreTripPreparation>.from(trip.preTripPreparations)
      ..removeWhere((p) => p.id == prepId);
    final updatedCompleted =
        List<String>.from(trip.completedPreTripPreparations)..remove(prepId);

    _trips[index] = trip.copyWith(
      preTripPreparations: updatedPreps,
      completedPreTripPreparations: updatedCompleted,
    );

    notifyListeners();
    await Future.wait([
      _saveTrips(),
      _notificationService.cancelNotification((tripId + prepId).hashCode),
    ]);
  }

  Future<void> addCustomPreTripPreparationToTrip(
    String tripId,
    String name,
    PreTripPreparationCategory category,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final newPrep = PreTripPreparation(
      id: _uuid.v4(),
      name: name,
      category: category,
      isCustom: true,
    );
    final updatedPreps = List<PreTripPreparation>.from(trip.preTripPreparations)
      ..add(newPrep);

    _trips[index] = trip.copyWith(preTripPreparations: updatedPreps);
    notifyListeners();
    await _saveTrips();
  }

  // ─── Home Checks ──────────────────────────────────────────────────────────
  Future<void> addCustomCheckToTrip(
    String tripId,
    String name,
    HomeCheckCategory category,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final newCheck = HomeCheck(
      id: _uuid.v4(),
      name: name,
      category: category,
      isCustom: true,
    );
    final updatedChecks = List<HomeCheck>.from(trip.homeChecks)..add(newCheck);

    _trips[index] = trip.copyWith(homeChecks: updatedChecks);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> toggleHomeCheck(String tripId, String checkId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final completed = List<String>.from(trip.completedHomeChecks);

    if (completed.contains(checkId)) {
      completed.remove(checkId);
    } else {
      completed.add(checkId);
    }

    _trips[index] = trip.copyWith(completedHomeChecks: completed);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> removeHomeCheckFromTrip(String tripId, String checkId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final updatedChecks = List<HomeCheck>.from(trip.homeChecks)
      ..removeWhere((c) => c.id == checkId);
    final updatedCompleted = List<String>.from(trip.completedHomeChecks)
      ..remove(checkId);

    _trips[index] = trip.copyWith(
      homeChecks: updatedChecks,
      completedHomeChecks: updatedCompleted,
    );
    notifyListeners();
    await _saveTrips();
  }

  Future<void> removeHomeCheckCategoryFromTrip(
    String tripId,
    HomeCheckCategory category,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final removedIds = trip.homeChecks
        .where((c) => c.category == category)
        .map((c) => c.id)
        .toSet();

    final updatedChecks = List<HomeCheck>.from(trip.homeChecks)
      ..removeWhere((c) => c.category == category);
    final updatedCompleted = List<String>.from(trip.completedHomeChecks)
      ..removeWhere((id) => removedIds.contains(id));

    _trips[index] = trip.copyWith(
      homeChecks: updatedChecks,
      completedHomeChecks: updatedCompleted,
    );
    notifyListeners();
    await _saveTrips();
  }

  Future<void> keepOnlyHomeChecksInTrip(
    String tripId,
    HomeCheckCategory category,
    List<String> checkIdsToKeep,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final removedIds = trip.homeChecks
        .where((c) => c.category == category && !checkIdsToKeep.contains(c.id))
        .map((c) => c.id)
        .toSet();

    final updatedChecks = List<HomeCheck>.from(trip.homeChecks)
      ..removeWhere((c) => removedIds.contains(c.id));
    final updatedCompleted = List<String>.from(trip.completedHomeChecks)
      ..removeWhere((id) => removedIds.contains(id));

    _trips[index] = trip.copyWith(
      homeChecks: updatedChecks,
      completedHomeChecks: updatedCompleted,
    );
    notifyListeners();
    await _saveTrips();
  }

  // ─── Category Operations ──────────────────────────────────────────────────
  Future<void> removeCategoryFromTrip(
    String tripId,
    ItemCategory category,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final updatedItems = List<TripItem>.from(trip.items)
      ..removeWhere((i) => i.category == category);

    _trips[index] = trip.copyWith(items: updatedItems);
    notifyListeners();
    await _saveTrips();
  }

  Future<void> keepOnlyItemsInTrip(
    String tripId,
    ItemCategory category,
    List<String> itemIdsToKeep,
  ) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    final trip = _trips[index];
    final updatedItems = List<TripItem>.from(trip.items)
      ..removeWhere(
        (i) => i.category == category && !itemIdsToKeep.contains(i.itemId),
      );

    _trips[index] = trip.copyWith(items: updatedItems);
    notifyListeners();
    await _saveTrips();
  }

  // ─── Trip Silme ───────────────────────────────────────────────────────────
  Future<void> deleteTrip(String id) async {
    final trip = getTripById(id);
    if (trip != null) {
      await Future.wait(
        trip.preTripPreparations.map(
          (prep) => _notificationService.cancelNotification(
            (id + prep.id).hashCode,
          ),
        ),
      );
    }

    _trips.removeWhere((t) => t.id == id);
    notifyListeners();
    await _saveTrips();
  }

  // ─── Admin (Manage Screen) ────────────────────────────────────────────────
  Future<void> addCustomItem(PackingItem item) async {
    final newItem = item.copyWith(
      id: _uuid.v4(),
      isCustom: true,
      isActive: true,
    );
    _allItems.add(newItem);
    notifyListeners();
    await _saveCustomItems();
  }

  Future<void> deleteCustomItem(String id) async {
    _allItems.removeWhere((i) => i.id == id && i.isCustom);
    notifyListeners();
    await _saveCustomItems();
  }

  Future<void> addCustomCheck(HomeCheck check) async {
    final newCheck = check.copyWith(
      id: _uuid.v4(),
      isCustom: true,
      isActive: true,
    );
    _allHomeChecks.add(newCheck);
    notifyListeners();
    await _saveCustomChecks();
  }

  Future<void> deleteCustomCheck(String id) async {
    _allHomeChecks.removeWhere((c) => c.id == id && c.isCustom);
    notifyListeners();
    await _saveCustomChecks();
  }

  Future<void> addCustomPreparation(PreTripPreparation preparation) async {
    final newPrep = preparation.copyWith(
      id: _uuid.v4(),
      isCustom: true,
      isActive: true,
    );
    _allPreTripPreparations.add(newPrep);
    notifyListeners();
    await _saveCustomPreparations();
  }

  Future<void> deleteCustomPreparation(String id) async {
    _allPreTripPreparations.removeWhere((p) => p.id == id && p.isCustom);
    notifyListeners();
    await _saveCustomPreparations();
  }

  // ─── Yardımcı ─────────────────────────────────────────────────────────────
  Trip? getTripById(String id) {
    return _trips.firstWhereOrNull((t) => t.id == id);
  }
}

// ✅ Extension - firstWhereOrNull
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
