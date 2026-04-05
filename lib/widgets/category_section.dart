import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import 'item_tile.dart';

class CategorySection extends StatelessWidget {
  final ItemCategory category;
  final List<dynamic> items;
  final String tripId;
  const CategorySection({super.key, required this.category, required this.items, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripItems = items.cast<TripItem>();
    final packedCount = tripItems.where((i) => i.isPacked).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(category.iconData, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(category.label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: packedCount == items.length ? Colors.green : theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('$packedCount/${items.length}', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          ...tripItems.map((item) => ItemTile(item: item, tripId: tripId)),
        ],
      ),
    );
  }
}
