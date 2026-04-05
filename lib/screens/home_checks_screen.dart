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
        if (trip == null) return const SizedBox.shrink();

        final completedChecks = trip.completedHomeChecks;
        final activeChecks = trip.homeChecks;

        final Map<HomeCheckCategory, List<HomeCheck>> grouped = {};
        for (final check in activeChecks) {
          grouped.putIfAbsent(check.category, () => []).add(check);
        }
        final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

        final totalChecks = activeChecks.length;
        final completedCount = completedChecks.length;
        final progress = totalChecks == 0 ? 0.0 : completedCount / totalChecks;

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ev Kontrolleri', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress, 
                            minHeight: 12, 
                            color: Colors.blueAccent,
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
                      color: Colors.blueAccent.withValues(alpha: 0.1), 
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '$completedCount/$totalChecks', 
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80), // Buton için alt boşluk eklendi
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final checks = grouped[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Row(
                          children: [
                            Icon(category.iconData, color: category.color, size: 20),
                            const SizedBox(width: 8),
                            Text(category.label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      ...checks.map((check) {
                        final isCompleted = completedChecks.contains(check.id);
                        return _HomeCheckTile(
                          check: check, 
                          isCompleted: isCompleted, 
                          tripId: tripId,
                          categoryColor: category.color,
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? categoryColor.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
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
              onPressed: () {
                HapticFeedback.heavyImpact();
                context.read<AppProvider>().removeHomeCheckFromTrip(tripId, check.id);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted ? categoryColor.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
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
            color: isCompleted ? Colors.white54 : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? categoryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isCompleted ? categoryColor : Colors.white24,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.black)
              : null,
        ),
      ),
    );
  }
}
