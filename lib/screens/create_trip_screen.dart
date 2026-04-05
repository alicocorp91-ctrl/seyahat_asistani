import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/enums.dart';
import '../providers/app_provider.dart';
import 'trip_item_selection_screen.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _nameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  
  Gender _gender = Gender.male;
  Season _season = Season.summer;
  Transport _transport = Transport.plane;
  TripType _tripType = TripType.domestic;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 4));

  @override
  void dispose() {
    _nameController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  int get _days => _endDate.difference(_startDate).inDays + 1;

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          if (picked.isAfter(_startDate) || picked.isAtSameMomentAs(_startDate)) {
            _endDate = picked;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy', 'tr_TR');

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Seyahat'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Seyahat Adi', hintText: 'Ornegin: Antalya Tatili', prefixIcon: Icon(Icons.edit)),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fromController,
                    decoration: const InputDecoration(labelText: 'Nereden', hintText: 'Istanbul', prefixIcon: Icon(Icons.flight_takeoff)),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _toController,
                    decoration: const InputDecoration(labelText: 'Nereye', hintText: 'Antalya', prefixIcon: Icon(Icons.flight_land)),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text('Seyahat Tipi', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<TripType>(
              segments: TripType.values.map((t) => ButtonSegment(value: t, label: Text(t.label), icon: Icon(t.iconData))).toList(),
              selected: {_tripType},
              onSelectionChanged: (set) {
                HapticFeedback.selectionClick();
                setState(() => _tripType = set.first);
              },
            ),
            const SizedBox(height: 24),

            Text('Tarihler', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateFormat.format(_startDate)),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateFormat.format(_endDate)),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('$_days gun', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),

            Text('Kisi Tipi', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<Gender>(
              segments: Gender.values.map((g) => ButtonSegment(value: g, label: Text(g.label), icon: Icon(g.iconData))).toList(),
              selected: {_gender},
              onSelectionChanged: (set) {
                HapticFeedback.selectionClick();
                setState(() => _gender = set.first);
              },
            ),
            const SizedBox(height: 24),

            Text('Mevsim', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Season.values.map((s) => FilterChip(
                selected: _season == s,
                label: Text(s.label),
                avatar: Icon(s.iconData, size: 18),
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  setState(() => _season = s);
                },
              )).toList(),
            ),
            const SizedBox(height: 24),

            Text('Ulasim Araci', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Transport.values.map((t) => FilterChip(
                selected: _transport == t,
                label: Text(t.label),
                avatar: Icon(t.iconData, size: 18),
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  setState(() => _transport = t);
                },
              )).toList(),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _createTrip,
                icon: const Icon(Icons.check),
                label: const Text('Seyahat Olustur'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createTrip() {
    final name = _nameController.text.trim();
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (name.isEmpty || from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lutfen tum alanlari doldurun')));
      return;
    }

    HapticFeedback.heavyImpact();

    final trip = context.read<AppProvider>().createTrip(
      name: name,
      fromLocation: from,
      toLocation: to,
      gender: _gender,
      season: _season,
      transport: _transport,
      tripType: _tripType,
      startDate: _startDate,
      endDate: _endDate,
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TripItemSelectionScreen(tripId: trip.id)));
  }
}
