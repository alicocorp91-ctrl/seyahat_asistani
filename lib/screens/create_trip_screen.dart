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
  final _formKey = GlobalKey<FormState>(); // ✅ Form key eklendi
  final _nameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  Gender _gender = Gender.male;
  Season _season = Season.summer;
  Transport _transport = Transport.plane;
  TripType _tripType = TripType.domestic;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 4));

  // ✅ Loading state - çift tıklama önleme
  bool _isCreating = false;

  // ✅ static - her build'de yeniden oluşturulmuyor
  static final _dateFormat = DateFormat('dd MMM yyyy', 'tr_TR');

  @override
  void dispose() {
    _nameController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  int get _days => _endDate.difference(_startDate).inDays + 1;

  Future<void> _selectDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      helpText: isStart ? 'Başlangıç Tarihi' : 'Bitiş Tarihi', // ✅
    );

    if (picked == null || !mounted) return; // ✅ mounted kontrolü

    setState(() {
      if (isStart) {
        _startDate = picked;
        // ✅ Bitiş tarihi başlangıçtan önce ise otomatik düzelt
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      } else {
        // ✅ Bitiş en az başlangıç günü olabilir (aynı gün tek gecelik)
        if (!picked.isBefore(_startDate)) {
          _endDate = picked;
        } else {
          // Kullanıcıyı bilgilendir
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bitiş tarihi başlangıç tarihinden önce olamaz'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Seyahat'),
        centerTitle: true,
      ),
      // ✅ Form widget'ı ile validation
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ TextFormField - validation ile
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Seyahat Adı', // ✅ Türkçe
                  hintText: 'Örneğin: Antalya Tatili', // ✅ Türkçe
                  prefixIcon: Icon(Icons.edit),
                ),
                textCapitalization: TextCapitalization.words,
                maxLength: 50, // ✅ Karakter sınırı
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Seyahat adı boş olamaz';
                  }
                  if (val.trim().length < 2) {
                    return 'En az 2 karakter girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fromController,
                      decoration: const InputDecoration(
                        labelText: 'Nereden',
                        hintText: 'İstanbul',
                        prefixIcon: Icon(Icons.flight_takeoff),
                      ),
                      textCapitalization: TextCapitalization.words,
                      maxLength: 30,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Nereden boş olamaz';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _toController,
                      decoration: const InputDecoration(
                        labelText: 'Nereye',
                        hintText: 'Antalya',
                        prefixIcon: Icon(Icons.flight_land),
                      ),
                      textCapitalization: TextCapitalization.words,
                      maxLength: 30,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Nereye boş olamaz';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text('Seyahat Tipi', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<TripType>(
                segments: TripType.values
                    .map((t) => ButtonSegment(
                          value: t,
                          label: Text(t.label),
                          icon: Icon(t.iconData),
                        ))
                    .toList(),
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
                      label: Text(_dateFormat.format(_startDate)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(false),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_dateFormat.format(_endDate)),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '$_days gün', // ✅ Türkçe
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text('Kişi Tipi', style: theme.textTheme.titleMedium), // ✅
              const SizedBox(height: 8),
              SegmentedButton<Gender>(
                segments: Gender.values
                    .map((g) => ButtonSegment(
                          value: g,
                          label: Text(g.label),
                          icon: Icon(g.iconData),
                        ))
                    .toList(),
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
                children: Season.values
                    .map((s) => FilterChip(
                          selected: _season == s,
                          label: Text(s.label),
                          avatar: Icon(s.iconData, size: 18),
                          onSelected: (_) {
                            HapticFeedback.selectionClick();
                            setState(() => _season = s);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              Text('Ulaşım Aracı', style: theme.textTheme.titleMedium), // ✅
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: Transport.values
                    .map((t) => FilterChip(
                          selected: _transport == t,
                          label: Text(t.label),
                          avatar: Icon(t.iconData, size: 18),
                          onSelected: (_) {
                            HapticFeedback.selectionClick();
                            setState(() => _transport = t);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                // ✅ Loading sırasında disabled
                child: FilledButton.icon(
                  onPressed: _isCreating ? null : _createTrip,
                  icon: _isCreating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: Text(
                      _isCreating ? 'Oluşturuluyor...' : 'Seyahat Oluştur'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createTrip() async {
    // ✅ Form validation
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // ✅ Çift tıklama koruması
    if (_isCreating) return;

    setState(() => _isCreating = true);

    try {
      HapticFeedback.heavyImpact();

      // ✅ await - createTrip artık async
      final trip = await context.read<AppProvider>().createTrip(
            name: _nameController.text.trim(),
            fromLocation: _fromController.text.trim(),
            toLocation: _toController.text.trim(),
            gender: _gender,
            season: _season,
            transport: _transport,
            tripType: _tripType,
            startDate: _startDate,
            endDate: _endDate,
          );

      // ✅ mounted kontrolü - async gap sonrası
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TripItemSelectionScreen(tripId: trip.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seyahat oluşturulamadı: $e')),
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }
}
