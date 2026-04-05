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
      appBar: AppBar(title: const Text('Ev Kontrollerini Yönet'), centerTitle: true),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<HomeCheckCategory, List<HomeCheck>> grouped = {};
          for (final check in provider.allHomeChecks) {
            grouped.putIfAbsent(check.category, () => []).add(check);
          }
          final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Buton icin alt bosluk eklendi
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(category: category, checks: grouped[category]!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCheckDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Kontrol Ekle'),
      ),
    );
  }

  void _showAddCheckDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const _AddCheckSheet());
  }
}

class _CategoryCard extends StatelessWidget {
  final HomeCheckCategory category;
  final List<HomeCheck> checks;
  const _CategoryCard({required this.category, required this.checks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = checks.where((c) => c.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(category.iconData, color: theme.colorScheme.secondary),
        title: Text(category.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$activeCount/${checks.length} aktif'),
        children: checks.map((check) {
          return ListTile(
            dense: true,
            leading: Switch(
              value: check.isActive,
              onChanged: (_) {
                HapticFeedback.selectionClick();
                context.read<AppProvider>().toggleCheckActive(check.id);
              },
            ),
            title: Text(check.name, style: TextStyle(color: check.isActive ? null : theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            trailing: check.isCustom
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<AppProvider>().deleteCustomCheck(check.id);
                    },
                  )
                : null,
          );
        }).toList(),
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
  HomeCheckCategory _category = HomeCheckCategory.other;

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
            Text('Yeni Kontrol Ekle', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Kontrol Adi', hintText: 'Ornegin: Balkon kapisini kapat', prefixIcon: Icon(Icons.edit)), textCapitalization: TextCapitalization.sentences),
            const SizedBox(height: 16),
            DropdownButtonFormField<HomeCheckCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Kategori', prefixIcon: Icon(Icons.category)),
              items: HomeCheckCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _addCheck, icon: const Icon(Icons.add), label: const Text('Ekle'))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addCheck() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lutfen kontrol adi girin')));
      return;
    }
    HapticFeedback.heavyImpact();
    context.read<AppProvider>().addCustomCheck(HomeCheck(id: '', name: name, category: _category));
    Navigator.pop(context);
  }
}
