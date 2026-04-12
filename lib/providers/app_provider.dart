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

class AppProvider extends ChangeNotifier {
  List<PackingItem> _allItems = [];
  List<HomeCheck> _allHomeChecks = [];
  List<PreTripPreparation> _allPreTripPreparations = [];
  List<Trip> _trips = [];
  Map<String, bool> _itemActiveStatus = {};
  Map<String, bool> _checkActiveStatus = {};
  Map<String, bool> _preparationActiveStatus = {};
  bool _isLoading = true;
  AppThemeMode _currentTheme = AppThemeMode.classicDark;

  List<PackingItem> get allItems => _allItems;
  List<HomeCheck> get allHomeChecks => _allHomeChecks;
  List<PreTripPreparation> get allPreTripPreparations => _allPreTripPreparations;
  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;
  AppThemeMode get currentTheme => _currentTheme;

  final _uuid = const Uuid();

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // Theme
    final themeIndex = prefs.getInt('app_theme_index') ?? 0;
    _currentTheme = AppThemeMode.values[themeIndex];

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

    // Preparation active status
    final preparationStatusJson = prefs.getString('preparation_status');
    if (preparationStatusJson != null) {
      _preparationActiveStatus = Map<String, bool>.from(jsonDecode(preparationStatusJson));
    }

    // Custom items
    final customItemsJson = prefs.getString('custom_items');
    List<PackingItem> customItems = [];
    if (customItemsJson != null) {
      customItems = (jsonDecode(customItemsJson) as List).map((e) => PackingItem.fromJson(e)).toList();
    }

    // Merge default + custom items
    _allItems = [
      ...defaultPackingItems.map((item) => item.copyWith(
        isActive: _itemActiveStatus[item.id] ?? item.isActive,
      )),
      ...customItems,
    ];

    // Custom home checks
    final customChecksJson = prefs.getString('custom_checks');
    List<HomeCheck> customChecks = [];
    if (customChecksJson != null) {
      customChecks = (jsonDecode(customChecksJson) as List).map((e) => HomeCheck.fromJson(e)).toList();
    }

    // Merge default + custom checks
    _allHomeChecks = [
      ...defaultHomeChecks.map((check) => check.copyWith(
        isActive: _checkActiveStatus[check.id] ?? check.isActive,
      )),
      ...customChecks,
    ];

    // Custom pre trip preparations
    final customPreparationsJson = prefs.getString('custom_preparations');
    List<PreTripPreparation> customPreparations = [];
    if (customPreparationsJson != null) {
      customPreparations = (jsonDecode(customPreparationsJson) as List).map((e) => PreTripPreparation.fromJson(e)).toList();
    }

    // Merge default + custom preparations
    _allPreTripPreparations = [
      ...defaultPreTripPreparations.map((prep) => prep.copyWith(
        isActive: _preparationActiveStatus[prep.id] ?? prep.isActive,
      )),
      ...customPreparations,
    ];

    // Trips
    final tripsJson = prefs.getString('trips');
    if (tripsJson != null) {
      _trips = (jsonDecode(tripsJson) as List).map((e) => Trip.fromJson(e)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode mode) async {
    _currentTheme = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_theme_index', mode.index);
    notifyListeners();
  }

  Future<void> _saveTrips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trips', jsonEncode(_trips.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveItemStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('item_status', jsonEncode(_itemActiveStatus));
  }

  Future<void> _saveCheckStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('check_status', jsonEncode(_checkActiveStatus));
  }

  Future<void> _savePreparationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preparation_status', jsonEncode(_preparationActiveStatus));
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

  Future<void> _saveCustomPreparations() async {
    final prefs = await SharedPreferences.getInstance();
    final customPreparations = _allPreTripPreparations.where((p) => p.isCustom).toList();
    await prefs.setString('custom_preparations', jsonEncode(customPreparations.map((e) => e.toJson()).toList()));
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

  // Toggle preparation active
  Future<void> togglePreparationActive(String id) async {
    final index = _allPreTripPreparations.indexWhere((p) => p.id == id);
    if (index != -1) {
      final preparation = _allPreTripPreparations[index];
      _allPreTripPreparations[index] = preparation.copyWith(isActive: !preparation.isActive);
      _preparationActiveStatus[id] = _allPreTripPreparations[index].isActive;
      await _savePreparationStatus();
      if (preparation.isCustom) await _saveCustomPreparations();
      notifyListeners();
    }
  }

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

    final tripHomeChecks = _allHomeChecks.where((c) => c.isActive).toList();

    final tripPreTripPreparations = _allPreTripPreparations.where((p) => 
      p.isActive && (tripType == TripType.international || !p.isForInternational)
    ).toList();

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
      homeChecks: tripHomeChecks,
      preTripPreparations: tripPreTripPreparations,
      completedHomeChecks: [],
      completedPreTripPreparations: [],
    );

    _trips.insert(0, trip);
    _saveTrips();
    notifyListeners();
    return trip;
  }

  Future<void> updateTripInitialSelection(String tripId, List<TripItem> items, List<HomeCheck> checks, List<PreTripPreparation> preparations) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      _trips[index] = _trips[index].copyWith(
        items: items,
        homeChecks: checks,
        preTripPreparations: preparations,
      );
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> toggleItemPacked(String tripId, String itemId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final itemIndex = trip.items.indexWhere((i) => i.itemId == itemId);
      if (itemIndex != -1) {
        final updatedItems = List<TripItem>.from(trip.items);
        updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(isPacked: !updatedItems[itemIndex].isPacked);
        _trips[index] = trip.copyWith(items: updatedItems);
        await _saveTrips();
        notifyListeners();
      }
    }
  }

  Future<void> removeItemFromTrip(String tripId, String itemId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final updatedItems = List<TripItem>.from(trip.items)..removeWhere((i) => i.itemId == itemId);
      _trips[index] = trip.copyWith(items: updatedItems);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> addItemToTrip(String tripId, String name, ItemCategory category) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final newItem = TripItem(itemId: _uuid.v4(), name: name, category: category);
      final updatedItems = List<TripItem>.from(trip.items)..add(newItem);
      _trips[index] = trip.copyWith(items: updatedItems);
      await _saveTrips();
      notifyListeners();
    }
  }

  // Pre Trip Preparation methods
  Future<void> togglePreTripPreparation(String tripId, String prepId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final completed = List<String>.from(trip.completedPreTripPreparations);
      if (completed.contains(prepId)) {
        completed.remove(prepId);
      } else {
        completed.add(prepId);
      }
      _trips[index] = trip.copyWith(completedPreTripPreparations: completed);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> removePreTripPreparationFromTrip(String tripId, String prepId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final updatedPreps = List<PreTripPreparation>.from(trip.preTripPreparations)..removeWhere((p) => p.id == prepId);
      final updatedCompleted = List<String>.from(trip.completedPreTripPreparations)..remove(prepId);
      _trips[index] = trip.copyWith(preTripPreparations: updatedPreps, completedPreTripPreparations: updatedCompleted);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> addCustomPreTripPreparationToTrip(String tripId, String name, PreTripPreparationCategory category) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final newPrep = PreTripPreparation(id: _uuid.v4(), name: name, category: category, isCustom: true);
      final updatedPreps = List<PreTripPreparation>.from(trip.preTripPreparations)..add(newPrep);
      _trips[index] = trip.copyWith(preTripPreparations: updatedPreps);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> addCustomCheckToTrip(String tripId, String name, HomeCheckCategory category) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final newCheck = HomeCheck(id: _uuid.v4(), name: name, category: category, isCustom: true);
      final updatedChecks = List<HomeCheck>.from(trip.homeChecks)..add(newCheck);
      _trips[index] = trip.copyWith(homeChecks: updatedChecks);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> removeCategoryFromTrip(String tripId, ItemCategory category) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final updatedItems = List<TripItem>.from(trip.items)..removeWhere((i) => i.category == category);
      _trips[index] = trip.copyWith(items: updatedItems);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> keepOnlyItemsInTrip(String tripId, ItemCategory category, List<String> itemIdsToKeep) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final updatedItems = List<TripItem>.from(trip.items)..removeWhere((i) => i.category == category && !itemIdsToKeep.contains(i.itemId));
      _trips[index] = trip.copyWith(items: updatedItems);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> toggleHomeCheck(String tripId, String checkId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final completed = List<String>.from(trip.completedHomeChecks);
      if (completed.contains(checkId)) {
        completed.remove(checkId);
      } else {
        completed.add(checkId);
      }
      _trips[index] = trip.copyWith(completedHomeChecks: completed);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> removeHomeCheckFromTrip(String tripId, String checkId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final updatedChecks = List<HomeCheck>.from(trip.homeChecks)..removeWhere((c) => c.id == checkId);
      final updatedCompleted = List<String>.from(trip.completedHomeChecks)..remove(checkId);
      _trips[index] = trip.copyWith(homeChecks: updatedChecks, completedHomeChecks: updatedCompleted);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> removeHomeCheckCategoryFromTrip(String tripId, HomeCheckCategory category) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final updatedChecks = List<HomeCheck>.from(trip.homeChecks)..removeWhere((c) => c.category == category);
      final removedCheckIds = trip.homeChecks.where((c) => c.category == category).map((c) => c.id).toList();
      final updatedCompleted = List<String>.from(trip.completedHomeChecks)..removeWhere((id) => removedCheckIds.contains(id));
      _trips[index] = trip.copyWith(homeChecks: updatedChecks, completedHomeChecks: updatedCompleted);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> keepOnlyHomeChecksInTrip(String tripId, HomeCheckCategory category, List<String> checkIdsToKeep) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      final trip = _trips[index];
      final checksToRemove = trip.homeChecks.where((c) => c.category == category && !checkIdsToKeep.contains(c.id)).map((c) => c.id).toList();
      final updatedChecks = List<HomeCheck>.from(trip.homeChecks)..removeWhere((c) => checksToRemove.contains(c.id));
      final updatedCompleted = List<String>.from(trip.completedHomeChecks)..removeWhere((id) => checksToRemove.contains(id));
      _trips[index] = trip.copyWith(homeChecks: updatedChecks, completedHomeChecks: updatedCompleted);
      await _saveTrips();
      notifyListeners();
    }
  }

  Future<void> deleteTrip(String id) async {
    _trips.removeWhere((t) => t.id == id);
    await _saveTrips();
    notifyListeners();
  }

  // Admin methods (Manage Screen)
  Future<void> addCustomItem(PackingItem item) async {
    final newItem = item.copyWith(id: _uuid.v4(), isCustom: true, isActive: true);
    _allItems.add(newItem);
    await _saveCustomItems();
    notifyListeners();
  }

  Future<void> deleteCustomItem(String id) async {
    _allItems.removeWhere((i) => i.id == id && i.isCustom);
    await _saveCustomItems();
    notifyListeners();
  }

  Future<void> addCustomCheck(HomeCheck check) async {
    final newCheck = check.copyWith(id: _uuid.v4(), isCustom: true, isActive: true);
    _allHomeChecks.add(newCheck);
    await _saveCustomChecks();
    notifyListeners();
  }

  Future<void> deleteCustomCheck(String id) async {
    _allHomeChecks.removeWhere((c) => c.id == id && c.isCustom);
    await _saveCustomChecks();
    notifyListeners();
  }

  Future<void> addCustomPreparation(PreTripPreparation preparation) async {
    final newPrep = preparation.copyWith(id: _uuid.v4(), isCustom: true, isActive: true);
    _allPreTripPreparations.add(newPrep);
    await _saveCustomPreparations();
    notifyListeners();
  }

  Future<void> deleteCustomPreparation(String id) async {
    _allPreTripPreparations.removeWhere((p) => p.id == id && p.isCustom);
    await _saveCustomPreparations();
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
