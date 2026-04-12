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
      appBar: AppBar(title: const Text('Hazırlıkları Yönet'), centerTitle: true),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final Map<PreTripPreparationCategory, List<PreTripPreparation>> grouped = {};
          for (final prep in provider.allPreTripPreparations) {
            grouped.putIfAbsent(prep.category, () => []).add(prep);
          }
          final categories = grouped.keys.toList()..sort((a, b) => a.index.compareTo(b.index));

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(category: category, preparations: grouped[category]!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPrepDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Hazırlık Ekle'),
      ),
    );
  }

  void _showAddPrepDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const _AddPrepSheet());
  }
}

class _CategoryCard extends StatelessWidget {
  final PreTripPreparationCategory category;
  final List<PreTripPreparation> preparations;
  const _CategoryCard({required this.category, required this.preparations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCount = preparations.where((p) => p.isActive).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(category.iconData, color: theme.colorScheme.secondary),
        title: Text(category.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$activeCount/${preparations.length} aktif'),
        children: preparations.map((prep) {
          return ListTile(
            dense: true,
            leading: Switch(
              value: prep.isActive,
              onChanged: (_) {
                HapticFeedback.selectionClick();
                context.read<AppProvider>().togglePreparationActive(prep.id);
              },
            ),
            title: Text(prep.name, style: TextStyle(color: prep.isActive ? null : theme.colorScheme.onSurface.withAlpha(128))),
            subtitle: prep.isForInternational ? const Text('Sadece Yurtdışı', style: TextStyle(fontSize: 10, color: Colors.orangeAccent)) : null,
            trailing: prep.isCustom
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<AppProvider>().deleteCustomPreparation(prep.id);
                    },
                  )
                : null,
          );
        }).toList(),
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
  PreTripPreparationCategory _category = PreTripPreparationCategory.travelPrep;
  bool _isForInternational = false;

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
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.onSurface.withAlpha(76), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Yeni Hazırlık Ekle', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Hazırlık Adı', hintText: 'Örneğin: Offline harita indir', prefixIcon: Icon(Icons.edit)), textCapitalization: TextCapitalization.sentences),
            const SizedBox(height: 16),
            DropdownButtonFormField<PreTripPreparationCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Kategori', prefixIcon: Icon(Icons.category)),
              items: PreTripPreparationCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Sadece Yurtdışı Seyahatler İçin'),
              value: _isForInternational,
              onChanged: (val) => setState(() => _isForInternational = val),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _addPrep, icon: const Icon(Icons.add), label: const Text('Ekle'))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addPrep() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen hazırlık adı girin')));
      return;
    }
    HapticFeedback.heavyImpact();
    context.read<AppProvider>().addCustomPreparation(PreTripPreparation(
      id: '', 
      name: name, 
      category: _category, 
      isForInternational: _isForInternational
    ));
    Navigator.pop(context);
  }
}
