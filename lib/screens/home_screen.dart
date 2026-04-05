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
        title: const Text('Seyahat Asistani'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.luggage_outlined, size: 80, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Henüz seyahat yok', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Yeni seyahat için + tuşuna basın', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.trips.length,
            itemBuilder: (context, index) => _TripCard(trip: provider.trips[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTripScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Seyahat'),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy', 'tr_TR');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip.id)));
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
              Row(
                children: [
                  Expanded(
                    child: Text(trip.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: trip.tripType.index == 0 ? Colors.blue.withValues(alpha: 0.2) : Colors.purple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: trip.tripType.index == 0 ? Colors.blue : Colors.purple, width: 0.5),
                    ),
                    child: Text(
                      trip.tripType.label, 
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: trip.tripType.index == 0 ? Colors.blue.shade200 : Colors.purple.shade200,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                  const SizedBox(width: 6),
                  Expanded(child: Text('${trip.fromLocation} → ${trip.toLocation}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.white54),
                  const SizedBox(width: 6),
                  Text('${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54)),
                  const Spacer(),
                  Text('${trip.days} gün', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _TripInfoBadge(icon: trip.season.iconData, label: trip.season.label, color: trip.season.color),
                  const SizedBox(width: 8),
                  _TripInfoBadge(icon: trip.transport.iconData, label: trip.transport.label, color: trip.transport.color),
                  const SizedBox(width: 8),
                  _TripInfoBadge(icon: trip.gender.iconData, label: trip.gender.label, color: trip.gender.color),
                ],
              ),
              const SizedBox(height: 16),
              if (!trip.hasStarted) ...[
                CountdownWidget(targetDate: trip.startDate),
                const SizedBox(height: 12),
              ],
              Row(
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
                  Text('${trip.packedCount}/${trip.totalCount}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Seyahati Sil', style: TextStyle(color: Colors.white)),
        content: Text('${trip.name} seyahatini silmek istiyor musunuz?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<AppProvider>().deleteTrip(trip.id);
              Navigator.pop(ctx);
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

  const _TripInfoBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
