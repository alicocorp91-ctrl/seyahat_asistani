import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Global hata yakalama
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('🔴 Flutter Hatası: ${details.exception}');
    debugPrint('Stack: ${details.stack}');
  };

  // ✅ Async hataları yakala
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('🔴 Platform Hatası: $error');
    debugPrint('Stack: $stack');
    return true;
  };

  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  // 1. Ekran yönünü sabitle
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 2. Türkçe tarih formatı
  try {
    await initializeDateFormatting('tr_TR', null);
  } catch (e) {
    debugPrint('⚠️ Tarih formatı başlatılamadı: $e');
  }

  // 3. Bildirim servisi
  try {
    await NotificationService().init();
  } catch (e) {
    debugPrint('⚠️ Bildirim servisi başlatılamadı: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..init(),
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Seyahat Asistanı',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(provider.currentTheme),
            themeMode: ThemeMode.dark,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('tr', 'TR'),
            ],
            locale: const Locale('tr', 'TR'),
            builder: (context, child) {
              ErrorWidget.builder = (FlutterErrorDetails details) {
                if (kDebugMode) {
                  return ErrorWidget(details.exception);
                }
                // ✅ FIX: const eklendi (prefer_const_constructors - satır 82)
                // _ProductionErrorWidget const constructor'a sahip olduğu için
                // çağrı yerinde de const kullanılabilir
                return const _ProductionErrorWidget(
                  message: 'Bir şeyler yanlış gitti.',
                );
              };
              return child ?? const SizedBox.shrink();
            },
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class _ProductionErrorWidget extends StatelessWidget {
  final String message;
  const _ProductionErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
