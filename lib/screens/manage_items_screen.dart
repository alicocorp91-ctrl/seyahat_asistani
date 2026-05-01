import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';
import '../models/item_model.dart';
import '../providers/app_provider.dart';

class ManageItemsScreen extends StatelessWidget {
  const ManageItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eşyaları Yönet'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<ItemCategory, List<PackingItem>> grouped = {};
          for (final item in provider.allItems) {
            grouped.putIfAbsent(item.category, () => []).add(item);
          }
          final categories = grouped.keys.toList()
            ..sort((a, b) => a.index.compareTo(b.index));

          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'Eşya bulunamadı',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _ItemCategoryCard(
                category: category,
                items: grouped[category]!,
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
            builder: (_) => const _AddItemSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Eşya Ekle'),
      ),
    );
  }
}

class _ItemCategoryCard extends StatelessWidget {
  final ItemCategory category;
  final List<PackingItem> items;

  const _ItemCategoryCard({
    required this.category,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = items.where((i) => i.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(category.iconData, color: theme.colorScheme.primary),
        title: Text(
          category.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$activeCount/${items.length} aktif'),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: items.map((item) => _ItemListTile(item: item)).toList(),
      ),
    );
  }
}

class _ItemListTile extends StatelessWidget {
  final PackingItem item;

  const _ItemListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      leading: Switch(
        value: item.isActive,
        onChanged: (_) {
          HapticFeedback.selectionClick();
          context.read<AppProvider>().toggleItemActive(item.id);
        },
      ),
      title: Text(
        item.name,
        style: TextStyle(
          color: item.isActive
              ? null
              // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 118)
              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
      subtitle: Text(
        item.genderVisibility.label,
        style: theme.textTheme.bodySmall,
      ),
      trailing: item.isCustom
          ? IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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
        title: const Text('Eşyayı Sil'),
        content: Text('"${item.name}" eşyasını silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AppProvider>().deleteCustomItem(item.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet();

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ItemCategory _category = ItemCategory.other;
  GenderVisibility _visibility = GenderVisibility.all;
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
                    // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 204)
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Yeni Eşya Ekle',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Eşya Adı',
                  hintText: 'Örneğin: Güneş gözlüğü',
                  prefixIcon: Icon(Icons.edit),
                ),
                textCapitalization: TextCapitalization.words,
                maxLength: 50,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Eşya adı boş olamaz';
                  }
                  if (val.trim().length < 2) {
                    return 'En az 2 karakter girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ItemCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ItemCategory.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.label),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GenderVisibility>(
                initialValue: _visibility,
                decoration: const InputDecoration(
                  labelText: 'Kimler Görsün',
                  prefixIcon: Icon(Icons.people),
                ),
                items: GenderVisibility.values
                    .map((v) => DropdownMenuItem(
                          value: v,
                          child: Text(v.label),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _visibility = val);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _addItem,
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

  Future<void> _addItem() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      HapticFeedback.heavyImpact();
      await context.read<AppProvider>().addCustomItem(
            PackingItem(
              id: '',
              name: _nameController.text.trim(),
              category: _category,
              genderVisibility: _visibility,
            ),
          );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eşya eklenemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
