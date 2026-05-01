import 'package:flutter/material.dart';
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
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final trip = provider.getTripById(tripId);

        if (trip == null) {
          return const Center(
            child: Text(
              'Seyahat bulunamadı',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        final activeChecks = trip.homeChecks;

        if (activeChecks.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, size: 64, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'Ev kontrolü yok',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        final grouped = _groupByCategory(activeChecks);
        final categories = grouped.keys.toList()
          ..sort((a, b) => a.index.compareTo(b.index));

        return Column(
          children: [
            _ProgressHeader(
              tripId: tripId,
              completedCount: trip.completedHomeChecks.length,
              totalCount: activeChecks.length,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CheckCategorySection(
                    category: category,
                    checks: grouped[category]!,
                    completedChecks: trip.completedHomeChecks,
                    tripId: tripId,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Map<HomeCheckCategory, List<HomeCheck>> _groupByCategory(
    List<HomeCheck> checks,
  ) {
    final Map<HomeCheckCategory, List<HomeCheck>> grouped = {};
    for (final check in checks) {
      grouped.putIfAbsent(check.category, () => []).add(check);
    }
    return grouped;
  }
}

class _ProgressHeader extends StatelessWidget {
  final String tripId;
  final int completedCount;
  final int totalCount;

  const _ProgressHeader({
    required this.tripId,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 118)
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ev Kontrolleri',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    color: primaryColor,
                    backgroundColor: Colors.white10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 152)
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              // ✅ FIX 3: withOpacity → withValues(alpha:) (satır 154)
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              '$completedCount/$totalCount',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckCategorySection extends StatelessWidget {
  final HomeCheckCategory category;
  final List<HomeCheck> checks;
  final List<String> completedChecks;
  final String tripId;

  const _CheckCategorySection({
    required this.category,
    required this.checks,
    required this.completedChecks,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...checks.map((check) => _HomeCheckTile(
              check: check,
              isCompleted: completedChecks.contains(check.id),
              tripId: tripId,
              categoryColor: category.color,
            )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _HomeCheckTile extends StatelessWidget {
  final HomeCheck check;
  final bool isCompleted;
  final String tripId;
  final Color categoryColor;

  const _HomeCheckTile({
    required this.check,
    required this.isCompleted,
    required this.tripId,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ✅ FIX 4: withOpacity → withValues(alpha:) (satır 244)
          color: isCompleted
              ? categoryColor.withValues(alpha: 0.3)
              // ✅ FIX 5: withOpacity → withValues(alpha:) (satır 245)
              : Colors.white.withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: ListTile(
        onTap: () {
          HapticFeedback.mediumImpact();
          context.read<AppProvider>().toggleHomeCheck(tripId, check.id);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.white24),
              onPressed: () => _confirmDelete(context),
              tooltip: 'Kaldır',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // ✅ FIX 6: withOpacity → withValues(alpha:) (satır 271)
                color: isCompleted
                    ? categoryColor.withValues(alpha: 0.2)
                    // ✅ FIX 7: withOpacity → withValues(alpha:) (satır 272)
                    : Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : check.category.iconData,
                size: 20,
                color: isCompleted ? categoryColor : Colors.blueGrey,
              ),
            ),
          ],
        ),
        title: Text(
          check.name,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: Colors.white54,
            color: isCompleted ? Colors.white54 : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: _CheckboxIndicator(
          isCompleted: isCompleted,
          color: categoryColor,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kontrolü Kaldır'),
        content: Text(
            '"${check.name}" kontrolünü listeden kaldırmak istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppProvider>().removeHomeCheckFromTrip(
                    tripId,
                    check.id,
                  );
            },
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
  }
}

class _CheckboxIndicator extends StatelessWidget {
  final bool isCompleted;
  final Color color;

  const _CheckboxIndicator({
    required this.isCompleted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isCompleted ? color : Colors.white24,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check, size: 16, color: Colors.black)
          : null,
    );
  }
}
