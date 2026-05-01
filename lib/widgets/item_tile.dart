import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/app_provider.dart';

class ItemTile extends StatelessWidget {
  final TripItem item;
  final String tripId;

  const ItemTile({
    super.key,
    required this.item,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPacked = item.isPacked;
    final categoryColor = item.category.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ✅ FIX 6: withOpacity → withValues(alpha:) (satır 32)
          color: isPacked
              ? categoryColor.withValues(alpha: 0.3)
              // ✅ FIX 7: withOpacity → withValues(alpha:) (satır 33)
              : Colors.white.withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: ListTile(
        onTap: () => _toggle(context),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.white24),
              onPressed: () => _confirmRemove(context),
              tooltip: 'Listeden çıkar',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // ✅ FIX 8: withOpacity → withValues(alpha:) (satır 59)
                color: isPacked
                    ? categoryColor.withValues(alpha: 0.2)
                    // ✅ FIX 9: withOpacity → withValues(alpha:) (satır 60)
                    : Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPacked ? Icons.check : item.category.iconData,
                size: 20,
                color: isPacked ? categoryColor : Colors.blueGrey,
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: theme.textTheme.bodyLarge?.copyWith(
                decoration: isPacked ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white54,
                color: isPacked ? Colors.white54 : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                // ✅ FIX 10: withOpacity → withValues(alpha:) (satır 92)
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.category.label,
                style: TextStyle(
                  color: categoryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: _CheckboxIndicator(
          isPacked: isPacked,
          color: categoryColor,
        ),
      ),
    );
  }

  void _toggle(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<AppProvider>().toggleItemPacked(tripId, item.itemId);
  }

  void _confirmRemove(BuildContext context) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eşyayı Çıkar'),
        content: Text(
          '"${item.name}" eşyasını listeden çıkarmak istiyor musunuz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppProvider>().removeItemFromTrip(
                    tripId,
                    item.itemId,
                  );
            },
            child: const Text('Çıkar'),
          ),
        ],
      ),
    );
  }
}

class _CheckboxIndicator extends StatelessWidget {
  final bool isPacked;
  final Color color;

  const _CheckboxIndicator({
    required this.isPacked,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isPacked ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPacked ? color : Colors.white24,
          width: 2,
        ),
      ),
      child: isPacked
          ? const Icon(Icons.check, size: 16, color: Colors.black)
          : null,
    );
  }
}
