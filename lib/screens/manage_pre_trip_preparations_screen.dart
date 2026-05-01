import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/pre_trip_preparation_model.dart';
import '../providers/app_provider.dart';

class ManagePreTripPreparationsScreen extends StatelessWidget {
  const ManagePreTripPreparationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazırlıkları Yönet'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<PreTripPreparationCategory, List<PreTripPreparation>>
              grouped = {};
          for (final prep in provider.allPreTripPreparations) {
            grouped.putIfAbsent(prep.category, () => []).add(prep);
          }
          final categories = grouped.keys.toList()
            ..sort((a, b) => a.index.compareTo(b.index));

          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'Hazırlık bulunamadı',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _PrepCategoryCard(
                category: category,
                preparations: grouped[category]!,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const _AddPrepSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Hazırlık Ekle'),
      ),
    );
  }
}

class _PrepCategoryCard extends StatelessWidget {
  final PreTripPreparationCategory category;
  final List<PreTripPreparation> preparations;

  const _PrepCategoryCard({
    required this.category,
    required this.preparations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = preparations.where((p) => p.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          category.iconData,
          color: theme.colorScheme.secondary,
        ),
        title: Text(
          category.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$activeCount/${preparations.length} aktif'),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children:
            preparations.map((prep) => _PrepListTile(prep: prep)).toList(),
      ),
    );
  }
}

class _PrepListTile extends StatelessWidget {
  final PreTripPreparation prep;

  const _PrepListTile({required this.prep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      leading: Switch(
        value: prep.isActive,
        onChanged: (_) {
          HapticFeedback.selectionClick();
          context.read<AppProvider>().togglePreparationActive(prep.id);
        },
      ),
      title: Text(
        prep.name,
        style: TextStyle(
          color: prep.isActive
              ? null
              // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 123)
              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
      subtitle: prep.isForInternational
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.public,
                  size: 12,
                  // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 134)
                  color: Colors.orangeAccent.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Sadece Yurt Dışı',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            )
          : null,
      trailing: prep.isCustom
          ? IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
              tooltip: 'Sil',
              onPressed: () => _confirmDelete(context),
            )
          : null,
    );
  }

  void _confirmDelete(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hazırlığı Sil'),
        content: Text('"${prep.name}" hazırlığını silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppProvider>().deleteCustomPreparation(prep.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _AddPrepSheet extends StatefulWidget {
  const _AddPrepSheet();

  @override
  State<_AddPrepSheet> createState() => _AddPrepSheetState();
}

class _AddPrepSheetState extends State<_AddPrepSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PreTripPreparationCategory _category = PreTripPreparationCategory.travelPrep;
  bool _isForInternational = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    // ✅ FIX 3: withOpacity → withValues(alpha:) (satır 229)
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Yeni Hazırlık Ekle',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Hazırlık Adı',
                  hintText: 'Örneğin: Offline harita indir',
                  prefixIcon: Icon(Icons.edit),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 50,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Hazırlık adı boş olamaz';
                  }
                  if (val.trim().length < 2) {
                    return 'En az 2 karakter girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PreTripPreparationCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                ),
                items: PreTripPreparationCategory.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.label),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Sadece Yurt Dışı Seyahatler İçin'),
                subtitle: const Text(
                  'Açıksa yurt içi seyahatlerde görünmez',
                  style: TextStyle(fontSize: 11),
                ),
                value: _isForInternational,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => _isForInternational = val),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _addPrep,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: Text(_isSaving ? 'Ekleniyor...' : 'Ekle'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addPrep() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      HapticFeedback.heavyImpact();
      await context.read<AppProvider>().addCustomPreparation(
            PreTripPreparation(
              id: '',
              name: _nameController.text.trim(),
              category: _category,
              isForInternational: _isForInternational,
            ),
          );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hazırlık eklenemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
