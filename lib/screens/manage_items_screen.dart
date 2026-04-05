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
      appBar: AppBar(title: const Text('Eşyaları Yönet'), centerTitle: true),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<ItemCategory, List<PackingItem>> grouped = {};
          for (final item in provider.allItems) {
            grouped.putIfAbsent(item.category, () => []).add(item);
          }
          final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), 
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(category: category, items: grouped[category]!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Eşya Ekle'),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const _AddItemSheet());
  }
}

class _CategoryCard extends StatelessWidget {
  final ItemCategory category;
  final List<PackingItem> items;
  const _CategoryCard({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = items.where((i) => i.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(category.iconData, color: theme.colorScheme.primary),
        title: Text(category.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$activeCount/${items.length} aktif'),
        children: items.map((item) {
          return ListTile(
            dense: true,
            leading: Switch(
              value: item.isActive,
              onChanged: (_) {
                HapticFeedback.selectionClick();
                context.read<AppProvider>().toggleItemActive(item.id);
              },
            ),
            title: Text(item.name, style: TextStyle(color: item.isActive ? null : theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            subtitle: Text(item.genderVisibility.label, style: theme.textTheme.bodySmall),
            trailing: item.isCustom
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<AppProvider>().deleteCustomItem(item.id);
                    },
                  )
                : null,
          );
        }).toList(),
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
  ItemCategory _category = ItemCategory.other;
  GenderVisibility _visibility = GenderVisibility.all;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Yeni Eşya Ekle', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Eşya Adı', prefixIcon: Icon(Icons.edit)), textCapitalization: TextCapitalization.words),
            const SizedBox(height: 16),
            DropdownButtonFormField<ItemCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kategori', prefixIcon: Icon(Icons.category)),
              items: ItemCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<GenderVisibility>(
              initialValue: _visibility,
              decoration: const InputDecoration(labelText: 'Kimler Görsün', prefixIcon: Icon(Icons.people)),
              items: GenderVisibility.values.map((v) => DropdownMenuItem(value: v, child: Text(v.label))).toList(),
              onChanged: (val) => setState(() => _visibility = val!),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _addItem, icon: const Icon(Icons.add), label: const Text('Ekle'))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen eşya adı girin')));
      return;
    }
    HapticFeedback.heavyImpact();
    context.read<AppProvider>().addCustomItem(PackingItem(id: '', name: name, category: _category, genderVisibility: _visibility));
    Navigator.pop(context);
  }
}
