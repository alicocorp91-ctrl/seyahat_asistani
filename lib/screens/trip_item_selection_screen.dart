import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../models/home_check_model.dart';
import '../models/pre_trip_preparation_model.dart';
import '../providers/app_provider.dart';
import 'trip_detail_screen.dart';

class TripItemSelectionScreen extends StatefulWidget {
  final String tripId;
  const TripItemSelectionScreen({super.key, required this.tripId});

  @override
  State<TripItemSelectionScreen> createState() =>
      _TripItemSelectionScreenState();
}

class _TripItemSelectionScreenState extends State<TripItemSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late List<TripItem> _allInitialItems;
  late List<HomeCheck> _allInitialChecks;
  late List<PreTripPreparation> _allInitialPreparations;

  final Set<String> _selectedItemIds = {};
  final Set<String> _selectedCheckIds = {};
  final Set<String> _selectedPreparationIds = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  void _initializeData() {
    final provider = context.read<AppProvider>();
    final trip = provider.getTripById(widget.tripId);
    if (trip == null) return;

    setState(() {
      _allInitialItems = List.from(trip.items);
      _allInitialChecks = List.from(trip.homeChecks);
      _allInitialPreparations = List.from(trip.preTripPreparations);

      _selectedItemIds.addAll(_allInitialItems.map((i) => i.itemId));
      _selectedCheckIds.addAll(_allInitialChecks.map((c) => c.id));
      _selectedPreparationIds.addAll(_allInitialPreparations.map((p) => p.id));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 1: Kullanılmayan 'theme' değişkeni kaldırıldı (unused_local_variable warning)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listeni Onayla'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hazırlıklar'),
            Tab(text: 'Eşya Önerileri'),
            Tab(text: 'Ev Kontrolleri'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPreparationsTab(),
          _buildItemsTab(),
          _buildChecksTab(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _isLoading ? null : _finalizeList,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Listeyi Onayla ve Başlat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionTab<T>({
    required List<T> allItems,
    required Set<String> selectedIds,
    required String Function(T) getId,
    required String Function(T) getName,
    required dynamic Function(T) getCategory,
    required String Function(dynamic) getCategoryLabel,
    required IconData Function(dynamic) getCategoryIcon,
    required Color Function(dynamic) getCategoryColor,
  }) {
    final Map<dynamic, List<T>> grouped = {};
    for (final item in allItems) {
      grouped.putIfAbsent(getCategory(item), () => []).add(item);
    }
    final categories = grouped.keys.toList()
      ..sort((a, b) => (a as dynamic).index.compareTo((b as dynamic).index));

    if (categories.isEmpty) {
      return const Center(
        child: Text('Öğe yok', style: TextStyle(color: Colors.white54)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final items = grouped[category]!;
        final allSelected = items.every((i) => selectedIds.contains(getId(i)));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryHeader(
              label: getCategoryLabel(category),
              icon: getCategoryIcon(category),
              color: getCategoryColor(category),
              allSelected: allSelected,
              onToggleAll: () {
                setState(() {
                  if (allSelected) {
                    // ✅ FIX 2 & 3: for döngülerine {} eklendi (curly_braces_in_flow_control_structures)
                    for (final i in items) {
                      selectedIds.remove(getId(i));
                    }
                  } else {
                    for (final i in items) {
                      selectedIds.add(getId(i));
                    }
                  }
                });
              },
            ),
            ...items.map((item) {
              final id = getId(item);
              final isSelected = selectedIds.contains(id);
              return _SelectionTile(
                title: getName(item),
                isSelected: isSelected,
                color: getCategoryColor(category),
                onToggle: () {
                  setState(() {
                    if (isSelected) {
                      selectedIds.remove(id);
                    } else {
                      selectedIds.add(id);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildItemsTab() => _buildSelectionTab<TripItem>(
        allItems: _allInitialItems,
        selectedIds: _selectedItemIds,
        getId: (i) => i.itemId,
        getName: (i) => i.name,
        getCategory: (i) => i.category,
        getCategoryLabel: (c) => (c as ItemCategory).label,
        getCategoryIcon: (c) => (c as ItemCategory).iconData,
        getCategoryColor: (c) => (c as ItemCategory).color,
      );

  Widget _buildChecksTab() => _buildSelectionTab<HomeCheck>(
        allItems: _allInitialChecks,
        selectedIds: _selectedCheckIds,
        getId: (c) => c.id,
        getName: (c) => c.name,
        getCategory: (c) => c.category,
        getCategoryLabel: (c) => (c as HomeCheckCategory).label,
        getCategoryIcon: (c) => (c as HomeCheckCategory).iconData,
        getCategoryColor: (c) => (c as HomeCheckCategory).color,
      );

  Widget _buildPreparationsTab() => _buildSelectionTab<PreTripPreparation>(
        allItems: _allInitialPreparations,
        selectedIds: _selectedPreparationIds,
        getId: (p) => p.id,
        getName: (p) => p.name,
        getCategory: (p) => p.category,
        getCategoryLabel: (c) => (c as PreTripPreparationCategory).label,
        getCategoryIcon: (c) => (c as PreTripPreparationCategory).iconData,
        getCategoryColor: (c) => (c as PreTripPreparationCategory).color,
      );

  Future<void> _finalizeList() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      HapticFeedback.heavyImpact();

      final finalItems = _allInitialItems
          .where((i) => _selectedItemIds.contains(i.itemId))
          .toList();
      final finalChecks = _allInitialChecks
          .where((c) => _selectedCheckIds.contains(c.id))
          .toList();
      final finalPreparations = _allInitialPreparations
          .where((p) => _selectedPreparationIds.contains(p.id))
          .toList();

      await context.read<AppProvider>().updateTripInitialSelection(
            widget.tripId,
            finalItems,
            finalChecks,
            finalPreparations,
          );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TripDetailScreen(tripId: widget.tripId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// ✅ Kategori başlığı ayrı widget
class _CategoryHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool allSelected;
  final VoidCallback onToggleAll;

  const _CategoryHeader({
    required this.label,
    required this.icon,
    required this.color,
    required this.allSelected,
    required this.onToggleAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onToggleAll,
            icon: Icon(
              allSelected
                  ? Icons.remove_circle_outline
                  : Icons.add_circle_outline,
              size: 16,
              color: color,
            ),
            label: Text(
              allSelected ? 'Tümünü Çıkar' : 'Tümünü Seç',
              style: TextStyle(color: color, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color color;
  final VoidCallback onToggle;

  const _SelectionTile({
    required this.title,
    required this.isSelected,
    required this.color,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // ✅ FIX 4, 5, 6, 7: withOpacity → withValues(alpha:) (deprecated_member_use)
        color: isSelected
            ? color.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? color.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ListTile(
        onTap: onToggle,
        dense: true,
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
          ),
        ),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isSelected ? color : Colors.white24,
          size: 20,
        ),
      ),
    );
  }
}
