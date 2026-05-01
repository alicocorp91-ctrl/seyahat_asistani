import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  // ✅ Singleton - uygulama genelinde tek instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // ✅ Bildirim kanalı sabitleri - magic string yok
  static const String _channelId = 'prep_channel';
  static const String _channelName = 'Hazırlık Hatırlatıcıları';
  static const String _channelDesc =
      'Seyahat hazırlık hatırlatıcıları için bildirim kanalı';

  Future<void> init() async {
    if (_initialized) return; // ✅ Çift init önleme

    try {
      // ✅ Timezone'ları başlat VE local timezone'u ayarla
      tz_data.initializeTimeZones();
      _setLocalTimezone();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // ✅ Android 13+ izinleri
      if (Platform.isAndroid) {
        await _requestAndroidPermissions();
      }

      _initialized = true;
      debugPrint('✅ NotificationService başarıyla başlatıldı');
    } catch (e, stack) {
      debugPrint('❌ NotificationService init hatası: $e');
      debugPrint('Stack: $stack');
      // Kritik değil, uygulama çalışmaya devam eder
    }
  }

  /// Türkiye timezone'unu ayarla
  void _setLocalTimezone() {
    try {
      // Türkiye için Europe/Istanbul
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    } catch (e) {
      debugPrint('⚠️ Timezone ayarlanamadı, UTC kullanılıyor: $e');
      // UTC'ye düş - en azından çalışır
    }
  }

  /// Bildirime tıklandığında
  void _onNotificationTap(NotificationResponse response) {
    debugPrint(
        '🔔 Bildirime tıklandı: ${response.id}, payload: ${response.payload}');
    // TODO: İleride deep link veya navigation eklenebilir
    // Örn: NavigationService.navigateTo('/trip/${response.payload}');
  }

  /// Android 13+ izin isteme
  Future<void> _requestAndroidPermissions() async {
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl == null) return;

      final notifGranted = await androidImpl.requestNotificationsPermission();
      debugPrint('📱 Bildirim izni: $notifGranted');

      final alarmGranted = await androidImpl.requestExactAlarmsPermission();
      debugPrint('⏰ Alarm izni: $alarmGranted');
    } catch (e) {
      debugPrint('⚠️ Android izin hatası: $e');
    }
  }

  /// Bildirim zamanla
  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload, // ✅ payload eklendi - deep link için
  }) async {
    if (!_initialized) {
      debugPrint('⚠️ NotificationService henüz başlatılmadı');
      return false;
    }

    // ✅ Geçmiş tarih kontrolü
    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('⚠️ Geçmiş tarihli bildirim zamanlanamaz: $scheduledDate');
      return false;
    }

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            // ✅ Büyük ikonlar ve stil
            styleInformation: BigTextStyleInformation(body),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      debugPrint('✅ Bildirim zamanlandı: id=$id, tarih=$scheduledDate');
      return true;
    } catch (e) {
      debugPrint('❌ Bildirim zamanlama hatası: $e');
      return false;
    }
  }

  /// Tek bildirimi iptal et
  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
      debugPrint('🗑️ Bildirim iptal edildi: id=$id');
    } catch (e) {
      debugPrint('❌ Bildirim iptal hatası: $e');
    }
  }

  /// Tüm bildirimleri iptal et
  Future<void> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      debugPrint('🗑️ Tüm bildirimler iptal edildi');
    } catch (e) {
      debugPrint('❌ Tüm bildirimler iptal hatası: $e');
    }
  }

  /// Aktif bildirimleri listele (debug için)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      return await _plugin.getActiveNotifications();
    } catch (e) {
      debugPrint('❌ Aktif bildirimler alınamadı: $e');
      return [];
    }
  }

  /// Bekleyen bildirimleri listele (debug için)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _plugin.pendingNotificationRequests();
    } catch (e) {
      debugPrint('❌ Bekleyen bildirimler alınamadı: $e');
      return [];
    }
  }
}
