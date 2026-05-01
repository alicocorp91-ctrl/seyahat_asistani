import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../models/trip_model.dart';
import '../providers/app_provider.dart';
import '../widgets/item_tile.dart';
import 'home_checks_screen.dart';
import 'pre_trip_preparations_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final String tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    _TabInfo(
      label: 'Hazırlık',
      icon: Icons.assignment_turned_in,
      color: Colors.purpleAccent,
      fabLabel: 'Hazırlık Ekle',
    ),
    _TabInfo(
      label: 'Eşyalar',
      icon: Icons.luggage,
      color: Colors.blueAccent,
      fabLabel: 'Eşya Ekle',
    ),
    _TabInfo(
      label: 'Ev Kontrol',
      icon: Icons.home_work,
      color: Colors.orangeAccent,
      fabLabel: 'Kontrol Ekle',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
          return Scaffold(
            appBar: AppBar(title: const Text('Hata')),
            body: const Center(
              child: Text('Seyahat bulunamadı'),
            ),
          );
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
                title: innerBoxIsScrolled
                    ? Text(
                        trip.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )
                    : null,
                centerTitle: true,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  tabBar: AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, _) => TabBar(
                      controller: _tabController,
                      tabs: _tabs
                          .asMap()
                          .entries
                          .map(
                            (e) => Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    e.value.icon,
                                    size: 16,
                                    color: _tabController.index == e.key
                                        ? e.value.color
                                        : Colors.white54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    e.value.label,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                PreTripPreparationsScreen(tripId: widget.tripId),
                _PackingListTab(trip: trip),
                HomeChecksScreen(tripId: widget.tripId),
              ],
            ),
          ),
          floatingActionButton: AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              final tabInfo = _tabs[_tabController.index];
              return FloatingActionButton.extended(
                onPressed: () => _handleFabPress(context, trip.id),
                icon: const Icon(Icons.add),
                label: Text(tabInfo.fabLabel),
                backgroundColor: tabInfo.color,
                foregroundColor: Colors.white,
              );
            },
          ),
        );
      },
    );
  }

  void _handleFabPress(BuildContext context, String tripId) {
    HapticFeedback.mediumImpact();
    switch (_tabController.index) {
      case 0:
        _showAddPrepDialog(context, tripId);
      case 1:
        _showAddItemDialog(context, tripId);
      case 2:
        _showAddCheckDialog(context, tripId);
    }
  }

  void _showAddItemDialog(BuildContext context, String tripId) {
    showDialog(
      context: context,
      builder: (ctx) => _AddItemDialog(tripId: tripId),
    );
  }

  void _showAddCheckDialog(BuildContext context, String tripId) {
    showDialog(
      context: context,
      builder: (ctx) => _AddCheckDialog(tripId: tripId),
    );
  }

  void _showAddPrepDialog(BuildContext context, String tripId) {
    showDialog(
      context: context,
      builder: (ctx) => _AddPrepDialog(tripId: tripId),
    );
  }
}

class _TabInfo {
  final String label;
  final IconData icon;
  final Color color;
  final String fabLabel;

  const _TabInfo({
    required this.label,
    required this.icon,
    required this.color,
    required this.fabLabel,
  });
}

class _AddItemDialog extends StatefulWidget {
  final String tripId;
  const _AddItemDialog({required this.tripId});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _controller = TextEditingController();
  ItemCategory _category = ItemCategory.clothingBasic;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Eşya Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Eşya adı...'),
            autofocus: true,
            maxLength: 50,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<ItemCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Kategori'),
            items: ItemCategory.values
                .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _category = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) return;
            context.read<AppProvider>().addItemToTrip(
                  widget.tripId,
                  name,
                  _category,
                );
            Navigator.pop(context);
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}

class _AddCheckDialog extends StatefulWidget {
  final String tripId;
  const _AddCheckDialog({required this.tripId});

  @override
  State<_AddCheckDialog> createState() => _AddCheckDialogState();
}

class _AddCheckDialogState extends State<_AddCheckDialog> {
  final _controller = TextEditingController();
  HomeCheckCategory _category = HomeCheckCategory.other;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Kontrol Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Kontrol adı...'),
            autofocus: true,
            maxLength: 50,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<HomeCheckCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Kategori'),
            items: HomeCheckCategory.values
                .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _category = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.orangeAccent),
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) return;
            context.read<AppProvider>().addCustomCheckToTrip(
                  widget.tripId,
                  name,
                  _category,
                );
            Navigator.pop(context);
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}

class _AddPrepDialog extends StatefulWidget {
  final String tripId;
  const _AddPrepDialog({required this.tripId});

  @override
  State<_AddPrepDialog> createState() => _AddPrepDialogState();
}

class _AddPrepDialogState extends State<_AddPrepDialog> {
  final _controller = TextEditingController();
  PreTripPreparationCategory _category = PreTripPreparationCategory.travelPrep;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Hazırlık Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Hazırlık adı...'),
            autofocus: true,
            maxLength: 50,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<PreTripPreparationCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Kategori'),
            items: PreTripPreparationCategory.values
                .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _category = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.purpleAccent),
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) return;
            context.read<AppProvider>().addCustomPreTripPreparationToTrip(
                  widget.tripId,
                  name,
                  _category,
                );
            Navigator.pop(context);
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}

class _TripHeader extends StatelessWidget {
  final Trip trip;
  const _TripHeader({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 440)
            primaryColor.withValues(alpha: 0.6),
            const Color(0xFF121212),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            trip.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.swap_calls,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${trip.fromLocation} → ${trip.toLocation}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _CircularProgress(
                progress: trip.progress,
                color: primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _InfoChip(
                icon: Icons.calendar_today,
                label: '${trip.days} gün',
                color: primaryColor,
              ),
              _InfoChip(
                icon: trip.season.iconData,
                label: trip.season.label,
                color: trip.season.color,
              ),
              _InfoChip(
                icon: trip.gender.iconData,
                label: trip.gender.label,
                color: trip.gender.color,
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              LinearProgressIndicator(
                value: trip.progress,
                backgroundColor: Colors.white10,
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
              ),
              const SizedBox(height: 12),
              Text(
                '${trip.packedCount} / ${trip.totalCount} eşya hazırlandı',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularProgress extends StatelessWidget {
  final double progress;
  final Color color;

  const _CircularProgress({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 54,
          height: 54,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Text(
          '%${(progress * 100).toInt()}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 594)
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        // ✅ FIX 3: withOpacity → withValues(alpha:) (satır 596)
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
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
    if (trip.items.isEmpty) {
      return const Center(
        child: Text(
          'Eşya yok',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    final Map<ItemCategory, List<TripItem>> grouped = {};
    for (final item in trip.items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final categories = grouped.keys.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final items = grouped[category]!;
        final packedCount = items.where((i) => i.isPacked).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              child: Row(
                children: [
                  Icon(category.iconData, color: category.color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    category.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$packedCount/${items.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
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

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;
  const _SliverTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => kTextTabBarHeight;

  @override
  double get maxExtent => kTextTabBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: const Color(0xFF121212),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar;
}
