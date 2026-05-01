import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/trip_model.dart';
import '../widgets/countdown_widget.dart';
import 'create_trip_screen.dart';
import 'trip_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seyahat Asistanı'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return _ErrorView(
              message: provider.error ?? 'Bir hata oluştu',
              onRetry: () => provider.init(),
            );
          }

          if (provider.trips.isEmpty) {
            return const _EmptyView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.trips.length,
            itemBuilder: (context, index) =>
                _TripCard(trip: provider.trips[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTripScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Seyahat'),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.luggage_outlined,
              size: 80,
              // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 94)
              color: primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz seyahat yok',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Yeni seyahat için + tuşuna basın',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;

  const _TripCard({required this.trip});

  static final _dateFormat = DateFormat('dd MMM yyyy', 'tr_TR');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripDetailScreen(tripId: trip.id),
            ),
          );
        },
        onLongPress: () {
          HapticFeedback.heavyImpact();
          _showDeleteDialog(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 12),
              _buildLocation(theme),
              const SizedBox(height: 8),
              _buildDates(theme),
              const SizedBox(height: 12),
              _buildBadges(),
              if (!trip.hasStarted) ...[
                const SizedBox(height: 16),
                CountdownWidget(targetDate: trip.startDate),
              ],
              const SizedBox(height: 16),
              _buildProgress(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final typeColor = trip.tripType.color;

    return Row(
      children: [
        Expanded(
          child: Text(
            trip.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 225)
            color: typeColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            // ✅ FIX 3: withOpacity → withValues(alpha:) (satır 227)
            border:
                Border.all(color: typeColor.withValues(alpha: 0.5), width: 0.5),
          ),
          child: Text(
            trip.tripType.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: typeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '${trip.fromLocation} → ${trip.toLocation}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDates(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 14, color: Colors.white54),
        const SizedBox(width: 6),
        Text(
          '${_dateFormat.format(trip.startDate)} - ${_dateFormat.format(trip.endDate)}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
        ),
        const Spacer(),
        Text(
          '${trip.days} gün',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _TripInfoBadge(
          icon: trip.season.iconData,
          label: trip.season.label,
          color: trip.season.color,
        ),
        _TripInfoBadge(
          icon: trip.transport.iconData,
          label: trip.transport.label,
          color: trip.transport.color,
        ),
        _TripInfoBadge(
          icon: trip.gender.iconData,
          label: trip.gender.label,
          color: trip.gender.color,
        ),
      ],
    );
  }

  Widget _buildProgress(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: trip.progress,
              minHeight: 8,
              backgroundColor: Colors.white10,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${trip.packedCount}/${trip.totalCount}',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seyahati Sil'),
        content: Text(
          '"${trip.name}" seyahatini silmek istiyor musunuz?\nBu işlem geri alınamaz.',
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
              context.read<AppProvider>().deleteTrip(trip.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _TripInfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TripInfoBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // ✅ FIX 4: withOpacity → withValues(alpha:) (satır 375)
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        // ✅ FIX 5: withOpacity → withValues(alpha:) (satır 377)
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
