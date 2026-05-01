import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/home_check_model.dart';
import '../providers/app_provider.dart';

class ManageHomeChecksScreen extends StatelessWidget {
  const ManageHomeChecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ev Kontrollerini Yönet'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<HomeCheckCategory, List<HomeCheck>> grouped = {};
          for (final check in provider.allHomeChecks) {
            grouped.putIfAbsent(check.category, () => []).add(check);
          }
          final categories = grouped.keys.toList()
            ..sort((a, b) => a.index.compareTo(b.index));

          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'Kontrol bulunamadı',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CheckCategoryCard(
                category: category,
                checks: grouped[category]!,
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
            builder: (_) => const _AddCheckSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Kontrol Ekle'),
      ),
    );
  }
}

class _CheckCategoryCard extends StatelessWidget {
  final HomeCheckCategory category;
  final List<HomeCheck> checks;

  const _CheckCategoryCard({
    required this.category,
    required this.checks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = checks.where((c) => c.isActive).length;

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
        subtitle: Text('$activeCount/${checks.length} aktif'),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: checks.map((check) => _CheckListTile(check: check)).toList(),
      ),
    );
  }
}

class _CheckListTile extends StatelessWidget {
  final HomeCheck check;

  const _CheckListTile({required this.check});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      leading: Switch(
        value: check.isActive,
        onChanged: (_) {
          HapticFeedback.selectionClick();
          context.read<AppProvider>().toggleCheckActive(check.id);
        },
      ),
      title: Text(
        check.name,
        style: TextStyle(
          color: check.isActive
              ? null
              // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 121)
              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
      trailing: check.isCustom
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
        title: const Text('Kontrolü Sil'),
        content: Text('"${check.name}" kontrolünü silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppProvider>().deleteCustomCheck(check.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _AddCheckSheet extends StatefulWidget {
  const _AddCheckSheet();

  @override
  State<_AddCheckSheet> createState() => _AddCheckSheetState();
}

class _AddCheckSheetState extends State<_AddCheckSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  HomeCheckCategory _category = HomeCheckCategory.other;
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
                    // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 205)
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Yeni Kontrol Ekle',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Kontrol Adı',
                  hintText: 'Örneğin: Balkon kapısını kapat',
                  prefixIcon: Icon(Icons.edit),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 50,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Kontrol adı boş olamaz';
                  }
                  if (val.trim().length < 2) {
                    return 'En az 2 karakter girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<HomeCheckCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                ),
                items: HomeCheckCategory.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.label),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _addCheck,
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

  Future<void> _addCheck() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      HapticFeedback.heavyImpact();
      await context.read<AppProvider>().addCustomCheck(
            HomeCheck(
              id: '',
              name: _nameController.text.trim(),
              category: _category,
            ),
          );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kontrol eklenemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
