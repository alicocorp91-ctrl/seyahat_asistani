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

  static const String _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle(title: 'Liste Yönetimi'),
          _ManagementTile(
            icon: Icons.luggage,
            title: 'Valiz Eşyalarını Yönet',
            subtitle: 'Eşya ekle, çıkar veya kapat',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageItemsScreen()),
            ),
          ),
          const SizedBox(height: 8),
          _ManagementTile(
            icon: Icons.home,
            title: 'Ev Kontrollerini Yönet',
            subtitle: 'Kontrol ekle, çıkar veya kapat',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ManageHomeChecksScreen(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _ManagementTile(
            icon: Icons.assignment_turned_in,
            title: 'Hazırlık Menüsünü Yönet',
            subtitle: 'Hazırlık ekle, çıkar veya kapat',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ManagePreTripPreparationsScreen(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Kişiselleştirme'),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: Icon(
                Icons.palette_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text(
                'Görünüm ve Tema',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Şu anki: ${provider.currentTheme.label}',
                style: const TextStyle(fontSize: 12),
              ),
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: _ThemeGrid(
                    currentTheme: provider.currentTheme,
                    onThemeSelected: (mode) {
                      HapticFeedback.mediumImpact();
                      provider.setTheme(mode);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Hakkında'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Seyahat Asistanı v$_appVersion',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Seyahatleriniz için her şey tek bir yerde. '
                    'Valiz hazırlığı, ev kontrolü ve seyahat öncesi '
                    'hazırlıklarınız artık çok daha kolay.',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
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

class _ManagementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
      ),
    );
  }
}

class _ThemeGrid extends StatelessWidget {
  final AppThemeMode currentTheme;
  final void Function(AppThemeMode) onThemeSelected;

  const _ThemeGrid({
    required this.currentTheme,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
        final isSelected = currentTheme == mode;

        return _ThemeCard(
          mode: mode,
          isSelected: isSelected,
          onTap: () => onThemeSelected(mode),
        );
      },
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final AppThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? mode.primaryColor : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
          // ✅ FIX 1: withOpacity → withValues(alpha:) (satır 227)
          color: isSelected
              ? mode.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
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
                          // ✅ FIX 2: withOpacity → withValues(alpha:) (satır 245)
                          color: mode.primaryColor.withValues(alpha: 0.4),
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
          // ✅ FIX 3: withOpacity → withValues(alpha:) (satır 286)
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
