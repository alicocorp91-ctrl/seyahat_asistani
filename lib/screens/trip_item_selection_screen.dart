import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../models/home_check_model.dart';
import '../providers/app_provider.dart';
import 'trip_detail_screen.dart';

class TripItemSelectionScreen extends StatefulWidget {
  final String tripId;
  const TripItemSelectionScreen({super.key, required this.tripId});

  @override
  State<TripItemSelectionScreen> createState() => _TripItemSelectionScreenState();
}

class _TripItemSelectionScreenState extends State<TripItemSelectionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<TripItem> _allInitialItems;
  late List<HomeCheck> _allInitialChecks;
  final List<String> _selectedItemIds = [];
  final List<String> _selectedCheckIds = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _initializeData(AppProvider provider) {
    if (_initialized) return;
    final trip = provider.getTripById(widget.tripId);
    if (trip != null) {
      _allInitialItems = List.from(trip.items);
      _allInitialChecks = List.from(trip.homeChecks);
      _selectedItemIds.addAll(_allInitialItems.map((i) => i.itemId));
      _selectedCheckIds.addAll(_allInitialChecks.map((c) => c.id));
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    _initializeData(provider);
    
    final trip = provider.getTripById(widget.tripId);
    if (trip == null) return const Scaffold(body: Center(child: Text('Hata')));

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Listeni Onayla'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          tabs: const [
            Tab(text: 'Eşya Önerileri'),
            Tab(text: 'Ev Kontrolleri'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildItemsTab(),
          _buildChecksTab(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _finalizeList,
          child: const Text('Listeyi Onayla ve Başlat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildItemsTab() {
    final Map<ItemCategory, List<TripItem>> grouped = {};
    for (final item in _allInitialItems) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final items = grouped[category]!;
        final allCategorySelected = items.every((i) => _selectedItemIds.contains(i.itemId));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  Icon(category.iconData, color: category.color, size: 20),
                  const SizedBox(width: 8),
                  Text(category.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (allCategorySelected) {
                          for (var i in items) {
                            _selectedItemIds.remove(i.itemId);
                          }
                        } else {
                          for (var i in items) {
                            if (!_selectedItemIds.contains(i.itemId)) {
                              _selectedItemIds.add(i.itemId);
                            }
                          }
                        }
                      });
                    },
                    icon: Icon(allCategorySelected ? Icons.remove_circle_outline : Icons.add_circle_outline, size: 16, color: category.color),
                    label: Text(allCategorySelected ? 'Tümünü Çıkar' : 'Tümünü Seç', style: TextStyle(color: category.color, fontSize: 12)),
                  ),
                ],
              ),
            ),
            ...items.map((item) {
              final isSelected = _selectedItemIds.contains(item.itemId);
              return _SelectionTile(
                title: item.name,
                isSelected: isSelected,
                color: category.color,
                onToggle: () {
                  setState(() {
                    if (isSelected) {
                      _selectedItemIds.remove(item.itemId);
                    } else {
                      _selectedItemIds.add(item.itemId);
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

  Widget _buildChecksTab() {
    final Map<HomeCheckCategory, List<HomeCheck>> grouped = {};
    for (final check in _allInitialChecks) {
      grouped.putIfAbsent(check.category, () => []).add(check);
    }
    final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final checks = grouped[category]!;
        final allCategorySelected = checks.every((c) => _selectedCheckIds.contains(c.id));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  Icon(category.iconData, color: category.color, size: 20),
                  const SizedBox(width: 8),
                  Text(category.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (allCategorySelected) {
                          for (var c in checks) {
                            _selectedCheckIds.remove(c.id);
                          }
                        } else {
                          for (var c in checks) {
                            if (!_selectedCheckIds.contains(c.id)) {
                              _selectedCheckIds.add(c.id);
                            }
                          }
                        }
                      });
                    },
                    icon: Icon(allCategorySelected ? Icons.remove_circle_outline : Icons.add_circle_outline, size: 16, color: category.color),
                    label: Text(allCategorySelected ? 'Tümünü Çıkar' : 'Tümünü Seç', style: TextStyle(color: category.color, fontSize: 12)),
                  ),
                ],
              ),
            ),
            ...checks.map((check) {
              final isSelected = _selectedCheckIds.contains(check.id);
              return _SelectionTile(
                title: check.name,
                isSelected: isSelected,
                color: category.color,
                onToggle: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCheckIds.remove(check.id);
                    } else {
                      _selectedCheckIds.add(check.id);
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

  void _finalizeList() {
    HapticFeedback.heavyImpact();
    
    final finalItems = _allInitialItems.where((i) => _selectedItemIds.contains(i.itemId)).toList();
    final finalChecks = _allInitialChecks.where((c) => _selectedCheckIds.contains(c.id)).toList();

    context.read<AppProvider>().updateTripInitialSelection(widget.tripId, finalItems, finalChecks);
    
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: widget.tripId))
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
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ListTile(
        onTap: onToggle,
        dense: true,
        title: Text(
          title, 
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white24,
            decoration: isSelected ? null : TextDecoration.lineThrough,
          )
        ),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.cancel_outlined,
          color: isSelected ? color : Colors.white12,
          size: 20,
        ),
      ),
    );
  }
}
