import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../models/trip_model.dart';
import '../models/home_check_model.dart';
import '../providers/app_provider.dart';
import '../widgets/item_tile.dart';
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
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFirstTab = _tabController.index == 0;

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final trip = provider.getTripById(widget.tripId);
        if (trip == null) {
          return Scaffold(appBar: AppBar(title: const Text('Hata')), body: const Center(child: Text('Seyahat bulunamadi')));
        }

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: const Color(0xFF121212),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _TripHeader(trip: trip),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: innerBoxIsScrolled ? Text(trip.name, style: const TextStyle(color: Colors.white, fontSize: 18)) : null,
                centerTitle: true,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: theme.colorScheme.primary,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: Colors.white54,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.luggage, size: 18, color: _tabController.index == 0 ? Colors.blueAccent : Colors.white54),
                            const SizedBox(width: 8),
                            const Text('Eşyalar'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_work, size: 18, color: _tabController.index == 1 ? Colors.orangeAccent : Colors.white54),
                            const SizedBox(width: 8),
                            const Text('Ev Kontrol'),
                          ],
                        ),
                      ),
                    ],
                    onTap: (index) => setState(() {}),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _PackingListTab(trip: trip),
                _HomeChecksTab(trip: trip),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => isFirstTab ? _showAddItemDialog(context, trip.id) : _showAddCheckDialog(context, trip.id),
            icon: const Icon(Icons.add),
            label: Text(isFirstTab ? 'Eşya Ekle' : 'Kontrol Ekle'),
            backgroundColor: isFirstTab ? Colors.blueAccent : Colors.orangeAccent,
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context, String tripId) {
    final controller = TextEditingController();
    ItemCategory selectedCategory = ItemCategory.clothingBasic;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Yeni Eşya Ekle', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Eşya adı...',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              DropdownButton<ItemCategory>(
                value: selectedCategory,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E1E1E),
                items: ItemCategory.values.map((c) => DropdownMenuItem(
                  value: c, 
                  child: Text(c.label, style: const TextStyle(color: Colors.white))
                )).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedCategory = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<AppProvider>().addItemToTrip(tripId, controller.text.trim(), selectedCategory);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Ekle', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCheckDialog(BuildContext context, String tripId) {
    final controller = TextEditingController();
    HomeCheckCategory selectedCategory = HomeCheckCategory.other;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Yeni Kontrol Ekle', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Kontrol adı...',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              DropdownButton<HomeCheckCategory>(
                value: selectedCategory,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E1E1E),
                items: HomeCheckCategory.values.map((c) => DropdownMenuItem(
                  value: c, 
                  child: Text(c.label, style: const TextStyle(color: Colors.white))
                )).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedCategory = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<AppProvider>().addCustomCheckToTrip(tripId, controller.text.trim(), selectedCategory);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Ekle', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripHeader extends StatelessWidget {
  final Trip trip;
  const _TripHeader({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D47A1), // Koyu Mavi
            Color(0xFF121212),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            trip.name,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.swap_calls, color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  Text('${trip.fromLocation} → ${trip.toLocation}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      value: trip.progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                  Text('%${(trip.progress * 100).toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(icon: Icons.calendar_today, label: '${trip.days} gün', color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              _InfoChip(icon: trip.season.iconData, label: trip.season.label, color: trip.season.color),
              const SizedBox(width: 8),
              _InfoChip(icon: trip.gender.iconData, label: trip.gender.label, color: trip.gender.color),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              LinearProgressIndicator(
                value: trip.progress,
                backgroundColor: Colors.white10,
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
              ),
              const SizedBox(height: 12),
              Text(
                '${trip.packedCount} / ${trip.totalCount} eşya hazırlandı',
                style: const TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _PackingListTab extends StatelessWidget {
  final Trip trip;
  const _PackingListTab({required this.trip});

  @override
  Widget build(BuildContext context) {
    final Map<ItemCategory, List<TripItem>> grouped = {};
    for (final item in trip.items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), 
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final items = grouped[category]!;
        final packedInCategory = items.where((i) => i.isPacked).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              child: Row(
                children: [
                  Icon(Icons.star, color: category.color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    category.label, 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10, 
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Text(
                      '$packedInCategory/${items.length}', 
                      style: const TextStyle(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ),
            ...items.map((item) => ItemTile(item: item, tripId: trip.id)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class _HomeChecksTab extends StatelessWidget {
  final Trip trip;
  const _HomeChecksTab({required this.trip});

  @override
  Widget build(BuildContext context) {
    return HomeChecksScreen(tripId: trip.id);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF121212),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
