import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/enums.dart';
import '../models/pre_trip_preparation_model.dart';
import '../providers/app_provider.dart';

class PreTripPreparationsScreen extends StatelessWidget {
  final String tripId;
  const PreTripPreparationsScreen({super.key, required this.tripId});

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

        final activePreps = trip.preTripPreparations;

        if (activePreps.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: Colors.white24,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Hazırlık yok',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        final grouped = _groupByCategory(activePreps);
        final categories = grouped.keys.toList()
          ..sort((a, b) => a.index.compareTo(b.index));

        return Column(
          children: [
            _ProgressHeader(
              completedCount: trip.completedPreTripPreparations.length,
              totalCount: activePreps.length,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _PrepCategorySection(
                    category: category,
                    preps: grouped[category]!,
                    completedPreps: trip.completedPreTripPreparations,
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

  static Map<PreTripPreparationCategory, List<PreTripPreparation>>
      _groupByCategory(List<PreTripPreparation> preps) {
    final Map<PreTripPreparationCategory, List<PreTripPreparation>> grouped =
        {};
    for (final prep in preps) {
      grouped.putIfAbsent(prep.category, () => []).add(prep);
    }
    return grouped;
  }
}

class _ProgressHeader extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const _ProgressHeader({
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 120)
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
                  'Hazırlık Menüsü',
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
              // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 153)
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              // ✅ FIX 3: withOpacity → withValues(alpha:) (satır 155)
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

class _PrepCategorySection extends StatelessWidget {
  final PreTripPreparationCategory category;
  final List<PreTripPreparation> preps;
  final List<String> completedPreps;
  final String tripId;

  const _PrepCategorySection({
    required this.category,
    required this.preps,
    required this.completedPreps,
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
        ...preps.map(
          (prep) => _PreTripPreparationTile(
            preparation: prep,
            isCompleted: completedPreps.contains(prep.id),
            tripId: tripId,
            categoryColor: category.color,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PreTripPreparationTile extends StatelessWidget {
  final PreTripPreparation preparation;
  final bool isCompleted;
  final String tripId;
  final Color categoryColor;

  static final _dateFormat = DateFormat('dd MMM, HH:mm', 'tr_TR');

  const _PreTripPreparationTile({
    required this.preparation,
    required this.isCompleted,
    required this.tripId,
    required this.categoryColor,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: preparation.scheduledDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('tr', 'TR'),
      helpText: 'Hatırlatıcı Tarihi',
      builder: (context, child) => _themedPicker(context, child),
    );

    if (pickedDate == null || !context.mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(preparation.scheduledDate ?? now),
      helpText: 'Hatırlatıcı Saati',
      builder: (context, child) => _themedPicker(context, child),
    );

    if (pickedTime == null || !context.mounted) return;

    final scheduledDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçmiş bir tarih seçildi. Bildirim gönderilmeyecek.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await context.read<AppProvider>().updatePreTripPreparation(
          tripId,
          preparation.copyWith(
            scheduledDate: scheduledDate,
            isNotificationEnabled: true,
          ),
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${preparation.name} için hatırlatıcı: ${_dateFormat.format(scheduledDate)}',
        ),
        backgroundColor: categoryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _themedPicker(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.dark(
          primary: categoryColor,
          onPrimary: Colors.black,
          surface: const Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSchedule = preparation.scheduledDate != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ✅ FIX 4: withOpacity → withValues(alpha:) (satır 329)
          color: isCompleted
              ? categoryColor.withValues(alpha: 0.3)
              // ✅ FIX 5: withOpacity → withValues(alpha:) (satır 330)
              : Colors.white.withValues(alpha: 0.05),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              HapticFeedback.mediumImpact();
              context
                  .read<AppProvider>()
                  .togglePreTripPreparation(tripId, preparation.id);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white24,
                  ),
                  onPressed: () => _confirmDelete(context),
                  tooltip: 'Kaldır',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // ✅ FIX 6: withOpacity → withValues(alpha:) (satır 365)
                    color: isCompleted
                        ? categoryColor.withValues(alpha: 0.2)
                        // ✅ FIX 7: withOpacity → withValues(alpha:) (satır 366)
                        : Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : preparation.category.iconData,
                    size: 20,
                    color: isCompleted ? categoryColor : Colors.blueGrey,
                  ),
                ),
              ],
            ),
            title: Text(
              preparation.name,
              style: TextStyle(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white54,
                color: isCompleted ? Colors.white54 : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: hasSchedule && !isCompleted
                ? Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        // ✅ FIX 8: withOpacity → withValues(alpha:) (satır 393)
                        color: categoryColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _dateFormat.format(preparation.scheduledDate!),
                        style: TextStyle(
                          // ✅ FIX 9: withOpacity → withValues(alpha:) (satır 399)
                          color: categoryColor.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      if (preparation.isNotificationEnabled) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.notifications_active,
                          size: 14,
                          // ✅ FIX 10: withOpacity → withValues(alpha:) (satır 408)
                          color: categoryColor.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  )
                : null,
            trailing: _CheckboxIndicator(
              isCompleted: isCompleted,
              color: categoryColor,
            ),
          ),
          if (!isCompleted)
            _ScheduleActions(
              hasSchedule: hasSchedule,
              isNotificationEnabled: preparation.isNotificationEnabled,
              categoryColor: categoryColor,
              onSelectTime: () => _selectDateTime(context),
              onToggleNotification: () {
                context.read<AppProvider>().updatePreTripPreparation(
                      tripId,
                      preparation.copyWith(
                        isNotificationEnabled:
                            !preparation.isNotificationEnabled,
                      ),
                    );
              },
              onClearSchedule: () {
                context.read<AppProvider>().updatePreTripPreparation(
                      tripId,
                      preparation.copyWith(clearScheduledDate: true),
                    );
              },
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hazırlığı Kaldır'),
        content: Text(
          '"${preparation.name}" hazırlığını listeden kaldırmak istiyor musunuz?',
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
              context.read<AppProvider>().removePreTripPreparationFromTrip(
                    tripId,
                    preparation.id,
                  );
            },
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
  }
}

class _ScheduleActions extends StatelessWidget {
  final bool hasSchedule;
  final bool isNotificationEnabled;
  final Color categoryColor;
  final VoidCallback onSelectTime;
  final VoidCallback onToggleNotification;
  final VoidCallback onClearSchedule;

  const _ScheduleActions({
    required this.hasSchedule,
    required this.isNotificationEnabled,
    required this.categoryColor,
    required this.onSelectTime,
    required this.onToggleNotification,
    required this.onClearSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, bottom: 8, right: 12),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onSelectTime,
            icon: Icon(
              hasSchedule ? Icons.edit_calendar : Icons.add_alarm,
              size: 18,
              color: categoryColor,
            ),
            label: Text(
              hasSchedule ? 'Zamanı Değiştir' : 'Zaman Planla',
              style: TextStyle(color: categoryColor, fontSize: 13),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          if (hasSchedule) ...[
            const Spacer(),
            IconButton(
              icon: Icon(
                isNotificationEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                size: 18,
                color: isNotificationEnabled ? categoryColor : Colors.white38,
              ),
              tooltip:
                  isNotificationEnabled ? 'Bildirimi Kapat' : 'Bildirimi Aç',
              onPressed: onToggleNotification,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_sweep,
                size: 18,
                color: Colors.redAccent,
              ),
              tooltip: 'Zamanı Sil',
              onPressed: onClearSchedule,
            ),
          ],
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
