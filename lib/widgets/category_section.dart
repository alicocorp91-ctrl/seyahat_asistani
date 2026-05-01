import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import 'item_tile.dart';

class CategorySection extends StatelessWidget {
  final ItemCategory category;
  final List<TripItem> items;
  final String tripId;

  const CategorySection({
    super.key,
    required this.category,
    required this.items,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final packedCount = items.where((i) => i.isPacked).length;
    final allPacked = packedCount == items.length && items.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 33)
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(category.iconData, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 59)
                    color: allPacked
                        ? Colors.green.withValues(alpha: 0.8)
                        : theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (allPacked) ...[
                        const Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '$packedCount/${items.length}',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Bu kategoride eşya yok',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            )
          else
            ...items.map((item) => ItemTile(item: item, tripId: tripId)),
        ],
      ),
    );
  }
}
