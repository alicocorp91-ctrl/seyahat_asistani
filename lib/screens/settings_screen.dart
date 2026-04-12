import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'manage_items_screen.dart';
import 'manage_home_checks_screen.dart';
import 'manage_pre_trip_preparations_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: 'Liste Yönetimi'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.luggage),
              title: const Text('Valiz Eşyalarını Yönet'),
              subtitle: const Text('Eşya ekle çıkar veya kapat'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageItemsScreen()));
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ev Kontrollerini Yönet'),
              subtitle: const Text('Kontrol ekle çıkar veya kapat'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageHomeChecksScreen()));
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.assignment_turned_in),
              title: const Text('Hazırlık Menüsünü Yönet'),
              subtitle: const Text('Hazırlık ekle çıkar veya kapat'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ManagePreTripPreparationsScreen()));
              },
            ),
          ),
          
          const SizedBox(height: 24),
          _SectionTitle(title: 'Kişiselleştirme'),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
              title: const Text('Görünüm ve Tema', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Şu anki: ${provider.currentTheme.label}', style: const TextStyle(fontSize: 12)),
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: AppThemeMode.values.length,
                    itemBuilder: (context, index) {
                      final mode = AppThemeMode.values[index];
                      final isSelected = provider.currentTheme == mode;
                      
                      return InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          provider.setTheme(mode);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? mode.primaryColor : Colors.white10,
                              width: isSelected ? 2 : 1,
                            ),
                            color: isSelected ? mode.primaryColor.withAlpha(25) : Colors.transparent,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: mode.primaryColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: mode.primaryColor.withAlpha(100),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check, color: Colors.white, size: 24),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mode.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _SectionTitle(title: 'Hakkında'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text('Seyahat Asistanı v1.2.0', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Seyahatleriniz için her şey tek bir yerde. Valiz hazırlığı, ev kontrolü ve seyahat öncesi hazırlıklarınız artık çok daha kolay.', style: TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary.withAlpha(180),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
